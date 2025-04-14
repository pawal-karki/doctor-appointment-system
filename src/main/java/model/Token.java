package model;

import java.time.LocalDateTime;

public class Token {
    private  int tokenId;
    private int userId;
    private String token;
    private String tokenType;
    private LocalDateTime expiresAt;

    public Token() {
    }

	public Token(int tokenId, int userId, String token, String tokenType, LocalDateTime expiresAt) {
		super();
		this.tokenId = tokenId;
		this.userId = userId;
		this.token = token;
		this.tokenType = tokenType;
		this.expiresAt = expiresAt;
	}

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

	public String getTokenType() {
		return tokenType;
	}

	public void setTokenType(String tokenType) {
		this.tokenType = tokenType;
	}

	public LocalDateTime getExpiresAt() {
		return expiresAt;
	}

	public void setExpiresAt(LocalDateTime expiresAt) {
		this.expiresAt = expiresAt;
	}
}

    