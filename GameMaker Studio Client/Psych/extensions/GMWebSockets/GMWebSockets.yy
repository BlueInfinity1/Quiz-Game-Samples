{
    "id": "3e45ba73-e2c9-4177-bdd3-2b8ec83c4ccd",
    "modelName": "GMExtension",
    "mvc": "1.2",
    "name": "GMWebSockets",
    "IncludedResources": [
        
    ],
    "androidPermissions": [
        
    ],
    "androidProps": false,
    "androidactivityinject": "",
    "androidclassname": "",
    "androidinject": "",
    "androidmanifestinject": "",
    "androidsourcedir": "",
    "author": "",
    "classname": "",
    "copyToTargets": 144150372447944736,
    "date": "2019-47-19 01:07:32",
    "description": "",
    "exportToGame": true,
    "extensionName": "",
    "files": [
        {
            "id": "5e785b82-ae6b-4709-ba8c-0b9c1b1ab624",
            "modelName": "GMExtensionFile",
            "mvc": "1.0",
            "ProxyFiles": [
                
            ],
            "constants": [
                {
                    "id": "5f877e26-7188-4711-b12b-e27f306cf735",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "socket_status_connecting",
                    "hidden": false,
                    "value": "0"
                },
                {
                    "id": "28a93c2c-0fdc-4979-9418-f0ace73f558f",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "socket_status_connected",
                    "hidden": false,
                    "value": "1"
                },
                {
                    "id": "90cefaca-c853-4ba0-a899-6c307a9f5bde",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "socket_status_closing",
                    "hidden": false,
                    "value": "2"
                },
                {
                    "id": "6620f478-edc6-4919-a486-9f981a0beddc",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "socket_status_closed",
                    "hidden": false,
                    "value": "3"
                },
                {
                    "id": "ec3309cd-21d1-4781-b483-70cedc0a76f2",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "socket_event_message",
                    "hidden": false,
                    "value": "\"websocket_message\""
                },
                {
                    "id": "3f6f1bb4-5968-4843-922e-3d95d46ed702",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "socket_event_connected",
                    "hidden": false,
                    "value": "\"websocket_connected\""
                },
                {
                    "id": "50f8bb4f-c9b4-4f89-b089-8372bcc139f4",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "socket_event_closed",
                    "hidden": false,
                    "value": "\"websocket_closed\""
                },
                {
                    "id": "8a7c521a-ca99-4257-81b1-ab31f5798834",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "socket_event_error",
                    "hidden": false,
                    "value": "\"websocket_error\""
                },
                {
                    "id": "f117cd5f-d09c-4068-ab91-f1dbef4a49c3",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "socket_protocol_json_only",
                    "hidden": false,
                    "value": "\"gmws_json_only\""
                },
                {
                    "id": "04850c0e-2b6f-4c25-bfbf-ef94614a7d8f",
                    "modelName": "GMExtensionConstant",
                    "mvc": "1.0",
                    "constantName": "async_websocket",
                    "hidden": false,
                    "value": "\"6164\""
                }
            ],
            "copyToTargets": 32,
            "filename": "gmwebsocket.js",
            "final": "",
            "functions": [
                {
                    "id": "ebb3b9bb-8fad-44e5-87e0-ef0ab8aabe32",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        2
                    ],
                    "externalName": "web_socket_debug_mode",
                    "help": "web_socket_debug_mode(True\/False debugMode);",
                    "hidden": false,
                    "kind": 5,
                    "name": "web_socket_debug_mode",
                    "returnType": 1
                },
                {
                    "id": "85ce3dfd-a75b-418a-8a5a-b36d65f97621",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        2
                    ],
                    "externalName": "web_socket_status",
                    "help": "web_socket_status(serverNumber);",
                    "hidden": false,
                    "kind": 5,
                    "name": "web_socket_status",
                    "returnType": 1
                },
                {
                    "id": "f5a680f9-7ad0-4c86-8fe5-f0eddf0146fd",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        
                    ],
                    "externalName": "web_socket_is_supported",
                    "help": "web_socket_is_supported();",
                    "hidden": false,
                    "kind": 5,
                    "name": "web_socket_is_supported",
                    "returnType": 1
                },
                {
                    "id": "26282d24-1ba4-44da-874b-9bf4bfd5f5a6",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        2,
                        1,
                        2,
                        2
                    ],
                    "externalName": "web_socket_open",
                    "help": "web_socket_open(Real connectionNumber, String serverAddress, dsList protocol, True\/False JSON Optimize);",
                    "hidden": false,
                    "kind": 5,
                    "name": "web_socket_open",
                    "returnType": 1
                },
                {
                    "id": "32cecc54-46fa-426e-b930-b8d9f674f5e1",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        2,
                        1
                    ],
                    "externalName": "web_socket_send",
                    "help": "web_socket_send(Real connectionNumber, String Data);",
                    "hidden": false,
                    "kind": 5,
                    "name": "web_socket_send",
                    "returnType": 1
                },
                {
                    "id": "ab07e7c4-2127-4d3a-8858-44b010b98bc8",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        2
                    ],
                    "externalName": "web_socket_close",
                    "help": "web_socket_close(Real connectionNumber);",
                    "hidden": false,
                    "kind": 5,
                    "name": "web_socket_close",
                    "returnType": 1
                }
            ],
            "init": "",
            "kind": 5,
            "order": [
                "ebb3b9bb-8fad-44e5-87e0-ef0ab8aabe32",
                "f5a680f9-7ad0-4c86-8fe5-f0eddf0146fd",
                "85ce3dfd-a75b-418a-8a5a-b36d65f97621",
                "26282d24-1ba4-44da-874b-9bf4bfd5f5a6",
                "32cecc54-46fa-426e-b930-b8d9f674f5e1",
                "ab07e7c4-2127-4d3a-8858-44b010b98bc8"
            ],
            "origname": "",
            "uncompress": false
        }
    ],
    "gradleinject": "",
    "helpfile": "",
    "installdir": "",
    "iosProps": false,
    "iosSystemFrameworkEntries": [
        
    ],
    "iosThirdPartyFrameworkEntries": [
        
    ],
    "iosdelegatename": "",
    "iosplistinject": "",
    "license": "",
    "maccompilerflags": "",
    "maclinkerflags": "",
    "macsourcedir": "",
    "options": null,
    "optionsFile": "options.json",
    "packageID": "",
    "productID": "",
    "sourcedir": "",
    "supportedTargets": 144150372447944736,
    "tvosProps": false,
    "tvosSystemFrameworkEntries": [
        
    ],
    "tvosThirdPartyFrameworkEntries": [
        
    ],
    "tvosclassname": "",
    "tvosdelegatename": "",
    "tvosmaccompilerflags": "",
    "tvosmaclinkerflags": "",
    "tvosplistinject": "",
    "version": "0.0.1"
}