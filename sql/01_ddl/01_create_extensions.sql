-- ============================================================================
-- FILE: 01_create_extensions.sql
-- PURPOSE: Initializes required PostgreSQL extensions for advanced data types,
--          indexing, and auditing.
-- AUTHOR: Senior Database Architect
-- ============================================================================

-- btree_gist allows combining standard equality operators (e.g., room_id = room_id)
-- with GiST range operators (e.g., daterange overlap). This is CRITICAL for
-- enforcing our strict no-double-booking policy.
CREATE EXTENSION IF NOT EXISTS btree_gist;

-- Provides cryptographic functions (useful for hashing sensitive data if expanded).
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Enables UUID generation for distributed systems (forward-looking for M6).
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";