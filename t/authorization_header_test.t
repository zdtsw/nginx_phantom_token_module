# vi:filetype=

use lib 'lib';
use Test::Nginx::Socket 'no_plan';
no_root_location();
run_tests();


__DATA__

=== TEST 1: 401 - No Authorization Header present
--- config
    location / {
        access_token_to_jwt_base64encoded_client_credentials "Y2xpZW50X2lkOmNsaWVudF9zZWNyZXQ=";
        access_token_to_jwt_introspection_endpoint curity;
		proxy_pass "http://httpbin.org/get";
    }
    location curity {
        proxy_pass "http://localhost:8443/mock-curity.php";
        proxy_set_header content-type "application/x-www-form-urlencoded";
    }
--- request
    GET /
--- error_code: 401

=== TEST 2: 401 - Authorization Header not Bearer
--- config
    location / {
		proxy_pass "http://httpbin.org/get";
        access_token_to_jwt_base64encoded_client_credentials "Y2xpZW50X2lkOmNsaWVudF9zZWNyZXQ=";
        access_token_to_jwt_introspection_endpoint curity;
    }
    location curity {
        proxy_pass "http://localhost:8443/mock-curity.php";
        proxy_set_header content-type "application/x-www-form-urlencoded";
    }
--- request
    GET /
--- more_headers
Authorization: Basic some_string
--- error_code: 401
