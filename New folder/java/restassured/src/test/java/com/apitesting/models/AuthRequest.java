package com.apitesting.models;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * POJO for the /auth endpoint — returns a token used in subsequent requests.
 */
public class AuthRequest {

    @JsonProperty("username")
    private String username;

    @JsonProperty("password")
    private String password;

    public AuthRequest() {}

    public AuthRequest(String username, String password) {
        this.username = username;
        this.password = password;
    }

    public String getUsername()         { return username; }
    public void setUsername(String v)   { this.username = v; }

    public String getPassword()         { return password; }
    public void setPassword(String v)   { this.password = v; }
}
