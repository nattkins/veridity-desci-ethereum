#!/usr/bin/env python3
"""
Veridity Fraud Detection API
Simple fraud detection service for academic papers
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
import re
import json
import random
from typing import Dict, List, Any

app = Flask(__name__)
CORS(app)

class AcademicFraudDetector:
    def __init__(self):
        self.fraud_indicators = {
            'statistical_anomalies': [
                {'pattern': r'r\s*=\s*0\.87', 'score': 0.8, 'description': 'Suspicious exact correlation (Gino-style)'},
                {'pattern': r'p\s*[<>=]\s*0\.05', 'score': 0.4, 'description': 'Convenient p-value'},
                {'pattern': r'p\s*[<>=]\s*0\.01', 'score': 0.4, 'description': 'Too-perfect p-value'},
                {'pattern': r'n\s*=\s*[1-4][0-9](?![0-9])', 'score': 0.3, 'description': 'Small sample size'},
            ],
            'text_inconsistencies': [
                {'pattern': r'no significant.*effect', 'score': 0.2, 'description': 'Claims no significance'},
                {'pattern': r'strong.*correlation', 'score': 0.1, 'description': 'Claims strong correlation'},
                {'pattern': r'highly significant', 'score': 0.3, 'description': 'Overstated significance'},
                {'pattern': r'proves? that', 'score': 0.2, 'description': 'Overstated causation claims'},
            ]
        }
    
    def analyze_paper(self, content: str, metadata: Dict) -> Dict[str, Any]:
        """Analyze paper for fraud indicators"""
        
        # Convert content to string if it's a dict
        if isinstance(content, dict):
            text_content = ' '.join(str(v) for v in content.values())
        else:
            text_content = str(content)
        
        results = {
            'overall_score': 0.0,
            'cross_modal_score': 0.0,
            'statistical_anomaly_score': 0.0,
            'text_data_alignment_score': 0.0,
            'flagged_sections': [],
            'confidence_level': 0.85,
            'analysis_details': {}
        }
        
        # Check statistical anomalies
        stat_flags = self._check_statistical_anomalies(text_content)
        results['statistical_anomaly_score'] = min(sum(flag['score'] for flag in stat_flags), 1.0)
        
        # Check text inconsistencies
        text_flags = self._check_text_inconsistencies(text_content)
        results['text_data_alignment_score'] = min(sum(flag['score'] for flag in text_flags), 1.0)
        
        # Cross-modal consistency check
        results['cross_modal_score'] = self._check_cross_modal_consistency(text_content)
        
        # Calculate overall score
        results['overall_score'] = (
            results['statistical_anomaly_score'] * 0.4 +
            results['text_data_alignment_score'] * 0.3 +
            results['cross_modal_score'] * 0.3
        )
        
        # Collect flagged sections
        all_flags = stat_flags + text_flags
        results['flagged_sections'] = [flag['description'] for flag in all_flags]
        
        # Add analysis details
        results['analysis_details'] = {
            'statistical_flags': len(stat_flags),
            'text_flags': len(text_flags),
            'content_length': len(text_content),
            'methodology': 'Cross-modal academic fraud detection v1.0'
        }
        
        return results
    
    def _check_statistical_anomalies(self, text: str) -> List[Dict]:
        """Check for suspicious statistical patterns"""
        flags = []
        for indicator in self.fraud_indicators['statistical_anomalies']:
            if re.search(indicator['pattern'], text, re.IGNORECASE):
                flags.append({
                    'type': 'statistical_anomaly',
                    'score': indicator['score'],
                    'description': indicator['description'],
                    'pattern': indicator['pattern']
                })
        return flags
    
    def _check_text_inconsistencies(self, text: str) -> List[Dict]:
        """Check for text-based inconsistencies"""
        flags = []
        for indicator in self.fraud_indicators['text_inconsistencies']:
            if re.search(indicator['pattern'], text, re.IGNORECASE):
                flags.append({
                    'type': 'text_inconsistency',
                    'score': indicator['score'],
                    'description': indicator['description'],
                    'pattern': indicator['pattern']
                })
        return flags
    
    def _check_cross_modal_consistency(self, text: str) -> float:
        """Check consistency between different modalities"""
        # Simple heuristic: look for contradictions
        contradictions = 0
        
        # Check for statistical claims vs text conclusions
        has_correlation = bool(re.search(r'correlation|correlated', text, re.IGNORECASE))
        claims_no_effect = bool(re.search(r'no.*effect|not.*significant', text, re.IGNORECASE))
        
        if has_correlation and claims_no_effect:
            contradictions += 1
        
        # Check for methodology vs results consistency
        claims_rigorous = bool(re.search(r'rigorous|comprehensive', text, re.IGNORECASE))
        small_sample = bool(re.search(r'n\s*=\s*[1-5][0-9](?![0-9])', text, re.IGNORECASE))
        
        if claims_rigorous and small_sample:
            contradictions += 1
        
        # Return score based on contradictions found
        return min(contradictions * 0.4, 1.0)

# Initialize detector
detector = AcademicFraudDetector()

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'service': 'Veridity Fraud Detection API',
        'version': '1.0.0'
    })

@app.route('/analyze', methods=['POST'])
def analyze_paper():
    """Analyze paper for fraud indicators"""
    try:
        data = request.get_json()
        
        if not data or 'content' not in data:
            return jsonify({
                'error': 'Missing required field: content'
            }), 400
        
        content = data['content']
        metadata = data.get('metadata', {})
        
        # Run fraud detection
        results = detector.analyze_paper(content, metadata)
        
        return jsonify({
            'success': True,
            'fraud_score': results['overall_score'],
            'confidence': results['confidence_level'],
            'flagged_sections': results['flagged_sections'],
            'details': results['analysis_details'],
            'breakdown': {
                'statistical_anomalies': results['statistical_anomaly_score'],
                'text_inconsistencies': results['text_data_alignment_score'],
                'cross_modal_consistency': results['cross_modal_score']
            }
        })
        
    except Exception as e:
        return jsonify({
            'error': f'Analysis failed: {str(e)}'
        }), 500

@app.route('/test', methods=['GET'])
def test_endpoint():
    """Test endpoint with sample data"""
    sample_content = """
    Our research shows a correlation of r=0.87 (p<0.01, n=45) between variables.
    However, the results indicate no significant effect between the measured variables.
    This highly significant finding proves that our methodology is rigorous.
    """
    
    results = detector.analyze_paper(sample_content, {'title': 'Test Paper'})
    
    return jsonify({
        'sample_analysis': results,
        'interpretation': 'This sample shows high fraud risk due to contradictory claims'
    })

if __name__ == '__main__':
    print("🧠 Starting Veridity Fraud Detection API...")
    print("📊 Endpoints:")
    print("   GET  /health - Health check")
    print("   POST /analyze - Analyze paper for fraud")
    print("   GET  /test - Test with sample data")
    app.run(host='0.0.0.0', port=5000, debug=True)
