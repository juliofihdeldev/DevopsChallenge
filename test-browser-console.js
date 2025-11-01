// Browser Console Test Script for Render Deployment
// Copy and paste this into your browser's developer console (F12)
// Base URL: https://devopschallenge.onrender.com

const BASE_URL = 'https://devopschallenge.onrender.com';

// Helper function to log responses
async function testEndpoint(method, endpoint, data = null) {
    try {
        const options = {
            method,
            headers: {
                'Content-Type': 'application/json',
            },
        };

        if (data) {
            options.body = JSON.stringify(data);
        }

        console.log(`\n${method} ${endpoint}`);
        const response = await fetch(`${BASE_URL}${endpoint}`, options);
        const result = await response.json();

        if (response.ok) {
            console.log('✅ SUCCESS:', result);
        } else {
            console.log(`❌ FAILED (${response.status}):`, result);
        }
        return result;
    } catch (error) {
        console.error('❌ ERROR:', error);
    }
}

// Run all tests
async function runAllTests() {
    console.log('=========================================');
    console.log('Testing Render Deployment Endpoints');
    console.log('=========================================\n');

    // 1. Health Check
    await testEndpoint('GET', '/healthz');

    // 2. Readiness Check
    await testEndpoint('GET', '/readyz');

    // 3. Service Live Status
    await testEndpoint('GET', '/api/items/live');

    // 4. Get All Items
    await testEndpoint('GET', '/api/items');

    // 5. Create Item
    const createResult = await testEndpoint('POST', '/api/items', { name: 'Test Item from Browser' });

    // 6. Get All Items (should now include the created item)
    await testEndpoint('GET', '/api/items');

    // 7. Get Item by ID (if item was created)
    if (createResult && createResult.id) {
        const itemId = createResult.id;
        await testEndpoint('GET', `/api/items/${itemId}`);

        // 8. Update Item
        await testEndpoint('PUT', `/api/items/${itemId}`, { name: 'Updated Item Name' });

        // 9. Verify Update
        await testEndpoint('GET', `/api/items/${itemId}`);

        // 10. Delete Item
        await testEndpoint('DELETE', `/api/items/${itemId}`);

        // 11. Verify Deletion (should return 404)
        await testEndpoint('GET', `/api/items/${itemId}`);
    }

    console.log('\n=========================================');
    console.log('Testing Complete!');
    console.log('=========================================');
}

// Uncomment to run all tests automatically:
// runAllTests();

// Or test individual endpoints:
// testEndpoint('GET', '/healthz');
// testEndpoint('GET', '/api/items');

