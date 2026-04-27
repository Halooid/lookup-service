CREATE TABLE lookup_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    key VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE lookup_values (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type_id UUID NOT NULL REFERENCES lookup_types(id) ON DELETE CASCADE,
    code VARCHAR(50) NOT NULL,
    name VARCHAR(255) NOT NULL,
    metadata JSONB,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE (type_id, code)
);

-- Seed some initial data
INSERT INTO lookup_types (key, description) VALUES 
('country', 'ISO 3166-1 alpha-2 country codes'),
('currency', 'ISO 4217 currency codes');

INSERT INTO lookup_values (type_id, code, name) VALUES 
((SELECT id FROM lookup_types WHERE key = 'country'), 'US', 'United States'),
((SELECT id FROM lookup_types WHERE key = 'country'), 'IN', 'India'),
((SELECT id FROM lookup_types WHERE key = 'country'), 'AE', 'United Arab Emirates'),
((SELECT id FROM lookup_types WHERE key = 'currency'), 'USD', 'US Dollar'),
((SELECT id FROM lookup_types WHERE key = 'currency'), 'INR', 'Indian Rupee'),
((SELECT id FROM lookup_types WHERE key = 'currency'), 'AED', 'UAE Dirham');
