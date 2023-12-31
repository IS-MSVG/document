function envoy_on_request(request_handle)
    local headers = request_handle:headers()
    local headersMap = {}
    for key, value in pairs(headers) do
      headersMap[key] = value
    end                
    request_handle:streamInfo():dynamicMetadata():set("envoy.lua","request_headers",headersMap)                    
    local requestBody = ""
    for chunk in request_handle:bodyChunks() do
      if (chunk:length() > 0) then
        requestBody = requestBody .. chunk:getBytes(0, chunk:length())
      end
    end
    request_handle:streamInfo():dynamicMetadata():set("envoy.lua","request_body",requestBody)                    
  end

  function envoy_on_response(response_handle)
    local headers = response_handle:headers()
    local headersMap = {}
    for key, value in pairs(headers) do
      headersMap[key] = value
    end                
    response_handle:streamInfo():dynamicMetadata():set("envoy.lua","response_headers",headersMap)                    
    local responseBody = ""
    for chunk in response_handle:bodyChunks() do
      if (chunk:length() > 0) then
        responseBody = responseBody .. chunk:getBytes(0, chunk:length())
      end
    end
    response_handle:streamInfo():dynamicMetadata():set("envoy.lua","response_body",responseBody)                    
  end