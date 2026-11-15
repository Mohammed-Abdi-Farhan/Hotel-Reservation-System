-- Postgres extensions required for the hotel reservation engine.

-- Enables GiST indexes on standard data types (integers, etc). 
-- This is strictly required for the EXCLUDE constraint we use to prevent double-booking.
CREATE EXTENSION IF NOT EXISTS btree_gist;

-- Standard utilities for hashing and UUID generation (reserved for future auth and distributed modules).
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";