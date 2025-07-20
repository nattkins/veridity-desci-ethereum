-- Veridity POC Database Schema
-- Academic publishing workflow tables

-- Academic papers table
CREATE TABLE academic_papers (
    id SERIAL PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    author_ens VARCHAR(100) NOT NULL,
    author_address VARCHAR(42),
    abstract TEXT,
    content_ipfs VARCHAR(100),
    keywords TEXT[],
    fraud_score DECIMAL(3,2) DEFAULT 0.00,
    status VARCHAR(50) DEFAULT 'submitted',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Peer reviewers table
CREATE TABLE peer_reviewers (
    id SERIAL PRIMARY KEY,
    ens_name VARCHAR(100) UNIQUE NOT NULL,
    wallet_address VARCHAR(42) UNIQUE NOT NULL,
    expertise_domains TEXT[],
    reputation_score INTEGER DEFAULT 100,
    total_reviews INTEGER DEFAULT 0,
    average_quality_score DECIMAL(3,2) DEFAULT 0.00,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Reviews table
CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    paper_id INTEGER REFERENCES academic_papers(id),
    reviewer_id INTEGER REFERENCES peer_reviewers(id),
    quality_score INTEGER CHECK (quality_score >= 1 AND quality_score <= 10),
    comments TEXT,
    recommendation VARCHAR(20) CHECK (recommendation IN ('accept', 'reject', 'revise')),
    usdc_payment_amount DECIMAL(10,2) DEFAULT 150.00,
    payment_status VARCHAR(20) DEFAULT 'pending',
    payment_tx_hash VARCHAR(66),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Fraud detection results table
CREATE TABLE fraud_detection_results (
    id SERIAL PRIMARY KEY,
    paper_id INTEGER REFERENCES academic_papers(id),
    overall_score DECIMAL(3,2),
    cross_modal_score DECIMAL(3,2),
    statistical_anomaly_score DECIMAL(3,2),
    text_data_alignment_score DECIMAL(3,2),
    flagged_sections TEXT[],
    confidence_level DECIMAL(3,2),
    analysis_details JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- EAS attestations table
CREATE TABLE eas_attestations (
    id SERIAL PRIMARY KEY,
    paper_id INTEGER REFERENCES academic_papers(id),
    attestation_uid VARCHAR(66) UNIQUE NOT NULL,
    schema_uid VARCHAR(66) NOT NULL,
    attester_address VARCHAR(42) NOT NULL,
    recipient_address VARCHAR(42) NOT NULL,
    attestation_data JSONB,
    tx_hash VARCHAR(66),
    block_number BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- USDC payments tracking
CREATE TABLE usdc_payments (
    id SERIAL PRIMARY KEY,
    review_id INTEGER REFERENCES reviews(id),
    recipient_address VARCHAR(42) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_type VARCHAR(20) DEFAULT 'review_payment',
    tx_hash VARCHAR(66),
    block_number BIGINT,
    gas_used BIGINT,
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for better performance
CREATE INDEX idx_papers_author ON academic_papers(author_ens);
CREATE INDEX idx_papers_status ON academic_papers(status);
CREATE INDEX idx_papers_created ON academic_papers(created_at);
CREATE INDEX idx_reviews_paper ON reviews(paper_id);
CREATE INDEX idx_reviews_reviewer ON reviews(reviewer_id);
CREATE INDEX idx_attestations_paper ON eas_attestations(paper_id);
CREATE INDEX idx_payments_recipient ON usdc_payments(recipient_address);

-- Insert sample data for testing
INSERT INTO peer_reviewers (ens_name, wallet_address, expertise_domains) VALUES
('alice.researcher.eth', '0x1234567890123456789012345678901234567890', ARRAY['computer science', 'machine learning']),
('bob.academic.eth', '0x2345678901234567890123456789012345678901', ARRAY['data science', 'statistics']),
('carol.professor.eth', '0x3456789012345678901234567890123456789012', ARRAY['blockchain', 'cryptography']);

-- Sample academic paper
INSERT INTO academic_papers (title, author_ens, abstract, keywords) VALUES
('Cross-Modal Fraud Detection in Academic Publishing',
 'researcher.university.eth',
 'This paper presents a novel approach to detecting academic fraud using cross-modal analysis of quantitative data and qualitative text.',
 ARRAY['fraud detection', 'academic integrity', 'machine learning']);

COMMIT;
