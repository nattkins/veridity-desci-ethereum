#!/bin/bash

# Submit test academic paper through the POC system
set -e

echo "📄 Submitting test academic paper..."

# Check if n8n workflow is active
if ! curl -f -s http://localhost:5678/healthz > /dev/null; then
    echo "❌ n8n is not running. Please start the POC environment first."
    exit 1
fi

# Sample paper data
PAPER_DATA='{
    "title": "Cross-Modal Fraud Detection in Academic Publishing: A Blockchain Approach",
    "author_ens": "alice.researcher.eth",
    "author_address": "0x1234567890123456789012345678901234567890",
    "abstract": "This paper presents a novel approach to detecting academic fraud using cross-modal analysis of quantitative data and qualitative text. We demonstrate how blockchain technology can provide immutable verification of research integrity.",
    "content": {
        "introduction": "Academic fraud is a growing concern in the research community. Traditional peer review processes are insufficient to detect sophisticated manipulation of data and conclusions.",
        "methodology": "We used statistical analysis combined with natural language processing to identify inconsistencies between quantitative results and qualitative conclusions. Our sample size was n=200 participants.",
        "results": "Our analysis showed a correlation of r=0.23 (p=0.14) between measured variables. The effect size was small but consistent across multiple trials.",
        "conclusion": "The results indicate a weak, non-significant relationship between the variables studied. This finding suggests that the effect, while measurable, may not be practically significant."
    },
    "keywords": ["fraud detection", "academic integrity", "blockchain", "cross-modal analysis"],
    "submitted_at": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'"
}'

echo "📊 Paper details:"
echo "   Title: Cross-Modal Fraud Detection in Academic Publishing"
echo "   Author: alice.researcher.eth"
echo "   Keywords: fraud detection, academic integrity, blockchain"
echo ""

# Submit paper (Note: This assumes the n8n workflow webhook is configured)
echo "🚀 Submitting to n8n workflow..."
echo "⚠️  Note: This requires the n8n workflow to be imported and active"
echo ""
echo "🔧 Manual submission options:"
echo ""
echo "Option 1 - Direct API call (if workflow webhook is active):"
echo "curl -X POST http://localhost:5678/webhook/submit-paper \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -d '$PAPER_DATA'"
echo ""
echo "Option 2 - Via NocoDB interface:"
echo "  1. Open http://localhost:8080"
echo "  2. Navigate to academic_papers table"
echo "  3. Click 'Add New Record'"
echo "  4. Fill in the paper details"
echo ""
echo "Option 3 - Direct database insertion:"
echo "docker exec veridity-postgres psql -U veridity -d veridity -c \\"
echo "  \"INSERT INTO academic_papers (title, author_ens, abstract, keywords) \\"
echo "   VALUES ('Cross-Modal Fraud Detection in Academic Publishing', \\"
echo "           'alice.researcher.eth', \\"
echo "           'Novel approach to detecting academic fraud...', \\"
echo "           ARRAY['fraud detection', 'blockchain']);\""
echo ""

# Try direct database insertion as fallback
echo "📝 Inserting test paper directly into database..."
docker exec veridity-postgres psql -U veridity -d veridity -c "
INSERT INTO academic_papers (title, author_ens, abstract, keywords, status) 
VALUES (
    'Cross-Modal Fraud Detection in Academic Publishing: A Blockchain Approach',
    'alice.researcher.eth',
    'This paper presents a novel approach to detecting academic fraud using cross-modal analysis of quantitative data and qualitative text.',
    ARRAY['fraud detection', 'academic integrity', 'blockchain', 'cross-modal analysis'],
    'submitted'
) RETURNING id, title, author_ens, created_at;
"

echo ""
echo "✅ Test paper submitted successfully!"
echo ""
echo "📊 Verify submission:"
echo "  Database: docker exec veridity-postgres psql -U veridity -d veridity -c 'SELECT * FROM academic_papers;'"
echo "  NocoDB: http://localhost:8080 (check academic_papers table)"
echo ""
echo "🧠 Test fraud detection on this paper:"
echo "curl -X POST http://localhost:5000/analyze -H 'Content-Type: application/json' -d '{\"content\": \"correlation r=0.23 p=0.14 no significant effect\", \"metadata\": {\"title\": \"Test Paper\"}}'"
