CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role VARCHAR(10) CHECK (role IN ('rider', 'driver')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE drivers (
    id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    vehicle_model VARCHAR(100),
    vehicle_plate VARCHAR(20) UNIQUE,
    is_available BOOLEAN DEFAULT false,
    current_location GEOGRAPHY(POINT, 4326),
    rating DECIMAL(3, 2) DEFAULT 5.0,
    is_on_trip BOOLEAN DEFAULT false
);

CREATE INDEX idx_driver_location ON drivers USING GIST (current_location);

CREATE TABLE rides (
    id UUID DEFAULT uuid_generate_v4(),
    rider_id UUID REFERENCES users(id),
    driver_id UUID REFERENCES users(id),
    status VARCHAR(20) DEFAULT 'requested' 
        CHECK (status IN ('requested', 'accepted', 'arrived', 'ongoing', 'completed', 'cancelled')),
    
    pickup_location GEOGRAPHY(POINT, 4326) NOT NULL,
    dropoff_location GEOGRAPHY(POINT, 4326) NOT NULL,
    pickup_address TEXT,
    dropoff_address TEXT,
    
    estimated_fare DECIMAL(10, 2),
    actual_fare DECIMAL(10, 2),
    surge_multiplier DECIMAL(3, 2) DEFAULT 1.0,
    distance_meters INTEGER,
    
    requested_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    accepted_at TIMESTAMP WITH TIME ZONE,
    started_at TIMESTAMP WITH TIME ZONE,
    ended_at TIMESTAMP WITH TIME ZONE,
    cancelled_at TIMESTAMP WITH TIME ZONE,
    cancellation_reason TEXT,
    
    PRIMARY KEY (id, requested_at)
) PARTITION BY RANGE (requested_at);

CREATE INDEX idx_rides_rider ON rides(rider_id);
CREATE INDEX idx_rides_driver ON rides(driver_id);
CREATE INDEX idx_rides_status ON rides(status);

CREATE TABLE rides_y2026m05 PARTITION OF rides
    FOR VALUES FROM ('2026-05-01 00:00:00+00') TO ('2026-06-01 00:00:00+00');

CREATE TABLE rides_y2026m06 PARTITION OF rides
    FOR VALUES FROM ('2026-06-01 00:00:00+00') TO ('2026-07-01 00:00:00+00');

CREATE TABLE rides_default PARTITION OF rides DEFAULT;

CREATE TABLE ride_tracking (
    id BIGSERIAL,
    ride_id UUID NOT NULL,
    coords GEOGRAPHY(POINT, 4326) NOT NULL,
    recorded_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (id, recorded_at)
) PARTITION BY RANGE (recorded_at);

CREATE INDEX idx_tracking_ride_id ON ride_tracking(ride_id);

CREATE TABLE ride_tracking_default PARTITION OF ride_tracking DEFAULT;

DO $$
DECLARE
    start_date DATE := '2026-01-01';
    end_date DATE := '2027-12-01'; 
    
    current_date_val DATE := start_date;
    next_date_val DATE;
    partition_name_rides TEXT;
    partition_name_tracking TEXT;
BEGIN
    WHILE current_date_val <= end_date LOOP
        next_date_val := current_date_val + INTERVAL '1 month';

        partition_name_rides := 'rides_y' || to_char(current_date_val, 'YYYY') || 'm' || to_char(current_date_val, 'MM');
        partition_name_tracking := 'ride_tracking_y' || to_char(current_date_val, 'YYYY') || 'm' || to_char(current_date_val, 'MM');

        EXECUTE format(
            'CREATE TABLE IF NOT EXISTS %I PARTITION OF rides FOR VALUES FROM (%L) TO (%L);',
            partition_name_rides, current_date_val, next_date_val
        );

        EXECUTE format(
            'CREATE TABLE IF NOT EXISTS %I PARTITION OF ride_tracking FOR VALUES FROM (%L) TO (%L);',
            partition_name_tracking, current_date_val, next_date_val
        );
        current_date_val := next_date_val;
    END LOOP;
    
    RAISE NOTICE 'Successfully created all partitions from % to %', start_date, end_date;
END $$;