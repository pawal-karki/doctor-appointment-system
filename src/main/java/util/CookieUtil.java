package util;

import java.security.SecureRandom;
import java.util.Base64;
import java.util.logging.Level;
import java.util.logging.Logger;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Utility class for managing cookies and authentication tokens
 */
public class CookieUtil {
    private static final Logger LOGGER = Logger.getLogger(CookieUtil.class.getName());
    
    // Cookie names
    public static final String REMEMBER_ME_COOKIE = "rememberMe";
    public static final String USER_EMAIL_COOKIE = "userEmail";
    
    // Cookie max age (30 days in seconds)
    private static final int COOKIE_MAX_AGE = 30 * 24 * 60 * 60;
    
    private CookieUtil() {
        // Private constructor to prevent instantiation
    }
    
    /**
     * Generate a secure random token for authentication
     * 
     * @return A base64 encoded secure random token
     */
    public static String generateRememberMeToken() {
        SecureRandom secureRandom = new SecureRandom();
        byte[] tokenBytes = new byte[32]; // 256 bits
        secureRandom.nextBytes(tokenBytes);
        return Base64.getEncoder().encodeToString(tokenBytes);
    }
    
    /**
     * Add a cookie with the specified name, value and max age
     * 
     * @param response The HttpServletResponse
     * @param name Cookie name
     * @param value Cookie value
     * @param maxAge Cookie max age in seconds, or -1 for a session cookie
     */
    public static void addCookie(HttpServletResponse response, String name, String value, int maxAge) {
        Cookie cookie = new Cookie(name, value);
        cookie.setMaxAge(maxAge);
        cookie.setPath("/");
        cookie.setHttpOnly(true); // Prevent JavaScript access
        cookie.setSecure(true); // Secure flag for HTTPS only
        response.addCookie(cookie);
        LOGGER.log(Level.FINE, "Added cookie: {0}", name);
    }
    
    /**
     * Add a remember me cookie with default max age
     * 
     * @param response The HttpServletResponse
     * @param token The authentication token
     */
    public static void addRememberMeCookie(HttpServletResponse response, String token) {
        addCookie(response, REMEMBER_ME_COOKIE, token, COOKIE_MAX_AGE);
    }
    
    /**
     * Add a user email cookie with default max age
     * 
     * @param response The HttpServletResponse
     * @param email The user's email
     */
    public static void addUserEmailCookie(HttpServletResponse response, String email) {
        addCookie(response, USER_EMAIL_COOKIE, email, COOKIE_MAX_AGE);
    }
    
    /**
     * Get a cookie by name
     * 
     * @param request The HttpServletRequest
     * @param name Cookie name
     * @return The cookie if found, null otherwise
     */
    public static Cookie getCookie(HttpServletRequest request, String name) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals(name)) {
                    return cookie;
                }
            }
        }
        return null;
    }
    
    /**
     * Get the value of a cookie by name
     * 
     * @param request The HttpServletRequest
     * @param name Cookie name
     * @return The cookie value if found, null otherwise
     */
    public static String getCookieValue(HttpServletRequest request, String name) {
        Cookie cookie = getCookie(request, name);
        return cookie != null ? cookie.getValue() : null;
    }
    
    /**
     * Remove a cookie
     * 
     * @param response The HttpServletResponse
     * @param name Cookie name
     */
    public static void removeCookie(HttpServletResponse response, String name) {
        Cookie cookie = new Cookie(name, "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);
        LOGGER.log(Level.FINE, "Removed cookie: {0}", name);
    }
    
    /**
     * Remove the remember me and user email cookies
     * 
     * @param response The HttpServletResponse
     */
    public static void removeAuthCookies(HttpServletResponse response) {
        removeCookie(response, REMEMBER_ME_COOKIE);
        removeCookie(response, USER_EMAIL_COOKIE);
    }
} 