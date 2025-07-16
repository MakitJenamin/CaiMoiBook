package mylib;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Utility class for hashing passwords and verifying password hashes
 */
public class PasswordHasher {
    
    /**
     * Hashes a password using SHA-256 with salt
     * 
     * @param password The password to hash
     * @return The hashed password with salt (format: salt:hash)
     */
    public static String hashPassword(String password) {
        try {
            // Generate a random salt
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[16];
            random.nextBytes(salt);
            
            // Create MessageDigest instance for SHA-256
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            
            // Add salt to digest
            md.update(salt);
            
            // Get the hashed password
            byte[] hashedPassword = md.digest(password.getBytes());
            
            // Convert salt and hash to Base64 for storage
            String saltString = Base64.getEncoder().encodeToString(salt);
            String hashString = Base64.getEncoder().encodeToString(hashedPassword);
            
            // Return salt and hash concatenated with a colon
            return saltString + ":" + hashString;
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
    
    /**
     * Verifies a password against a stored hash
     * 
     * @param password The password to verify
     * @param storedHash The stored hash to verify against (format: salt:hash)
     * @return true if the password matches, false otherwise
     */
    public static boolean verifyPassword(String password, String storedHash) {
        try {
            // Split the stored hash into salt and hash
            String[] parts = storedHash.split(":");
            if (parts.length != 2) {
                return false;
            }
            
            // Decode the salt and hash from Base64
            byte[] salt = Base64.getDecoder().decode(parts[0]);
            byte[] hash = Base64.getDecoder().decode(parts[1]);
            
            // Create MessageDigest instance for SHA-256
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            
            // Add salt to digest
            md.update(salt);
            
            // Get the hashed password
            byte[] hashedPassword = md.digest(password.getBytes());
            
            // Compare the hashed password with the stored hash
            if (hash.length != hashedPassword.length) {
                return false;
            }
            
            // Compare each byte
            for (int i = 0; i < hash.length; i++) {
                if (hash[i] != hashedPassword[i]) {
                    return false;
                }
            }
            
            return true;
        } catch (NoSuchAlgorithmException | IllegalArgumentException e) {
            return false;
        }
    }
} 