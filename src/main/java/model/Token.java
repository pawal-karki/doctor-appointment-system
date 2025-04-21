package model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Token implements Serializable {
    private int tokenId;
    private int userId;
    private String token;
    private TokenType tokenType;
    private LocalDateTime expiresAt;
    
    public enum TokenType {
        REMEMBER_ME,
        PASSWORD_RESET
    }
    
    public Token() {
    }
    
    public Token(int tokenId, int userId, String token, TokenType tokenType, LocalDateTime expiresAt) {
        this.tokenId = tokenId;
        this.userId = userId;
        this.token = token;
        this.tokenType = tokenType;
        this.expiresAt = expiresAt;
    }
    
    // Getters and Setters
    public int getTokenId() {
        return tokenId;
    }
    
    public void setTokenId(int tokenId) {
        this.tokenId = tokenId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getToken() {
        return token;
    }
    
    public void setToken(String token) {
        this.token = token;
    }
    
    public TokenType getTokenType() {
        return tokenType;
    }
    
    public void setTokenType(TokenType tokenType) {
        this.tokenType = tokenType;
    }
    
    public LocalDateTime getExpiresAt() {
        return expiresAt;
    }
    
    public void setExpiresAt(LocalDateTime expiresAt) {
        this.expiresAt = expiresAt;
    }
    
    public boolean isExpired() {
        return LocalDateTime.now().isAfter(expiresAt);
    }
} 