#!/usr/bin/env python3
"""Test MCP server connection"""
import subprocess
import json
import sys
import time

def test_mcp_server():
    """Test if MCP server can start and respond"""

    # Start the MCP server
    proc = subprocess.Popen(
        ["uv", "run", "mcp-server"],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        cwd="addons/godot_mcp_enhanced/python",
        text=True,
        bufsize=1
    )

    try:
        # Send initialize request
        init_request = {
            "jsonrpc": "2.0",
            "id": 1,
            "method": "initialize",
            "params": {
                "protocolVersion": "2024-11-05",
                "capabilities": {},
                "clientInfo": {"name": "test", "version": "1.0"}
            }
        }

        print("Sending initialize request...")
        proc.stdin.write(json.dumps(init_request) + "\n")
        proc.stdin.flush()

        # Wait for response
        print("Waiting for response...")
        time.sleep(2)

        # Read response
        response = proc.stdout.readline()
        if response:
            print(f"Response: {response}")
            resp_data = json.loads(response)
            print(f"Parsed response: {json.dumps(resp_data, indent=2)}")
        else:
            print("No response received")

        # Check stderr
        proc.stderr.flush()
        errors = proc.stderr.read()
        if errors:
            print(f"Errors: {errors}")

    except Exception as e:
        print(f"Error: {e}")
    finally:
        proc.terminate()
        proc.wait()

if __name__ == "__main__":
    test_mcp_server()
