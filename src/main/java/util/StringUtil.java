package util;

/**
 * Utility class for String operations
 */
public class StringUtil {
    
    /**
     * Checks if a string is null or empty
     * 
     * @param str The string to check
     * @return true if the string is null or empty, false otherwise
     */
    public static boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }
    
    /**
     * Checks if a string is not null and not empty
     * 
     * @param str The string to check
     * @return true if the string is not null and not empty, false otherwise
     */
    public static boolean isNotEmpty(String str) {
        return !isEmpty(str);
    }
    
    /**
     * Safely gets a string value, returning an empty string if null
     * 
     * @param str The string to check
     * @return The original string or an empty string if null
     */
    public static String safeString(String str) {
        return str == null ? "" : str;
    }
    
    /**
     * Checks if a string ends with a specific suffix
     * 
     * @param str The string to check
     * @param suffix The suffix to check for
     * @return true if the string ends with the suffix, false otherwise
     */
    public static boolean endsWith(String str, String suffix) {
        return str != null && str.endsWith(suffix);
    }
    
    /**
     * Truncates a string to a maximum length, adding ellipsis if truncated
     * 
     * @param str The string to truncate
     * @param maxLength The maximum length
     * @return The truncated string
     */
    public static String truncate(String str, int maxLength) {
        if (str == null) {
            return "";
        }
        
        if (str.length() <= maxLength) {
            return str;
        }
        
        return str.substring(0, maxLength) + "...";
    }
}
