package dao;

import java.io.IOException;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Database connection utility class
 */
public class DBConnection {
    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());
    
    // Database connection parameters
    private static String JDBC_DRIVER;
    private static String DB_URL;
    private static String USER;
    private static String PASSWORD;
    
    // Connection pool size
    private static int MIN_CONNECTIONS = 5;
    private static int MAX_CONNECTIONS = 20;
    private static Connection[] connectionPool;
    private static boolean[] connectionInUse;
    private static final List<Connection> overflowConnections = new ArrayList<>();
    
    static {
        try {
            // Load properties from configuration file
            loadProperties();
            
            // Load JDBC driver
            Class.forName(JDBC_DRIVER);
            
            // Initialize connection pool
            connectionPool = new Connection[MAX_CONNECTIONS];
            connectionInUse = new boolean[MAX_CONNECTIONS];
            
            for (int i = 0; i < MIN_CONNECTIONS; i++) {
                connectionPool[i] = createConnection();
                connectionInUse[i] = false;
            }
            
            LOGGER.log(Level.INFO, "Database connection pool initialized with {0} connections", MIN_CONNECTIONS);
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "JDBC Driver not found", e);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error initializing database connection pool", e);
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error loading database properties", e);
        }
    }
    
    /**
     * Load database properties from configuration file
     * 
     * @throws IOException if an error occurs while reading the properties file
     */
    private static void loadProperties() throws IOException {
        Properties props = new Properties();
        InputStream inputStream = DBConnection.class.getClassLoader().getResourceAsStream("database.properties");
        
        if (inputStream != null) {
            props.load(inputStream);
            
            JDBC_DRIVER = props.getProperty("db.driver", "com.mysql.cj.jdbc.Driver");
            DB_URL = props.getProperty("db.url", "jdbc:mysql://localhost:3306/doc_appointment_db?useSSL=false");
            USER = props.getProperty("db.username", "root");
            PASSWORD = props.getProperty("db.password", "");
            MIN_CONNECTIONS = Integer.parseInt(props.getProperty("db.min.connections", "5"));
            MAX_CONNECTIONS = Integer.parseInt(props.getProperty("db.max.connections", "20"));
            
            inputStream.close();
        } else {
            // Fallback to default values if properties file is not found
            LOGGER.log(Level.WARNING, "database.properties file not found, using default values");
            JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
            DB_URL = "jdbc:mysql://localhost:3306/doc_appointment_db?useSSL=false";
            USER = "root";
            PASSWORD = "";
            MIN_CONNECTIONS = 5;
            MAX_CONNECTIONS = 20;
        }
    }
    
    /**
     * Get a connection from the pool
     * 
     * @return A database connection
     * @throws SQLException if a database access error occurs
     */
    public static synchronized Connection getConnection() throws SQLException {
        // Initialize any uninitialized connections up to MAX_CONNECTIONS as needed
        for (int i = 0; i < MAX_CONNECTIONS; i++) {
            if (connectionPool[i] == null) {
                connectionPool[i] = createConnection();
                connectionInUse[i] = false;
            }
        }
        
        // Try to find an available connection in the pool
        for (int i = 0; i < MAX_CONNECTIONS; i++) {
            if (!connectionInUse[i]) {
                // Check if connection is still valid
                if (connectionPool[i] == null || connectionPool[i].isClosed()) {
                    connectionPool[i] = createConnection();
                }
                
                connectionInUse[i] = true;
                return connectionPool[i];
            }
        }
        
        // If no connection is available, create a new one
        LOGGER.log(Level.WARNING, "Connection pool exhausted, creating new connection");
        Connection overflowConn = createConnection();
        overflowConnections.add(overflowConn);
        return overflowConn;
    }
    
    /**
     * Release a connection back to the pool
     * 
     * @param conn The connection to release
     */
    public static synchronized void releaseConnection(Connection conn) {
        // First try to release from the main pool
        for (int i = 0; i < MAX_CONNECTIONS; i++) {
            if (connectionPool[i] == conn) {
                connectionInUse[i] = false;
                return;
            }
        }
        
        // If not in main pool, try to release from overflow connections
        if (overflowConnections.remove(conn)) {
            try {
                conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing overflow connection", e);
            }
        }
    }
    
    /**
     * Create a new database connection
     * 
     * @return A new database connection
     * @throws SQLException if a database access error occurs
     */
    private static Connection createConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, USER, PASSWORD);
    }
    
    /**
     * Close all connections in the pool
     */
    public static synchronized void closeAllConnections() {
        for (int i = 0; i < MAX_CONNECTIONS; i++) {
            try {
                if (connectionPool[i] != null && !connectionPool[i].isClosed()) {
                    connectionPool[i].close();
                }
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing database connection", e);
            }
        }
        LOGGER.log(Level.INFO, "All database connections closed");
    }
}
