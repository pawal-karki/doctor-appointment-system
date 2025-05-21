package model;

import java.io.Serializable;

public class User implements Serializable {
    private int userId;
    private String name;
    private String email;
    private String password;
    private String phone;
    private String role; // "admin" or "user"
    private String imageUrl;
    private boolean verified; // Whether user has verified their email
    private String otpCode; // Verification OTP code
    private long otpExpiry; // OTP expiration timestamp
    
    public User() {
    }
    
    public User(int userId, String name, String email, String password, String phone, String role) {
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.role = role;
        this.verified = false;
    }
    
    // Getters and Setters
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public boolean isVerified() {
        return verified;
    }
    
    public void setVerified(boolean verified) {
        this.verified = verified;
    }
    
    public String getOtpCode() {
        return otpCode;
    }
    
    public void setOtpCode(String otpCode) {
        this.otpCode = otpCode;
    }
    
    public long getOtpExpiry() {
        return otpExpiry;
    }
    
    public void setOtpExpiry(long otpExpiry) {
        this.otpExpiry = otpExpiry;
    }
    
    public boolean isAdmin() {
        return "admin".equals(role);
    }
    
    // For backward compatibility
    public int getId() {
        return userId;
    }
    
    public void setId(int id) {
        this.userId = id;
    }
}
