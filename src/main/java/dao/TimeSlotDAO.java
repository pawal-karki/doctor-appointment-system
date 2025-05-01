package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.DoctorTimeSlot;
import model.TimeSlot;

public class TimeSlotDAO {
    
    public List<TimeSlot> getAllTimeSlots() {
        List<TimeSlot> timeSlots = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            String sql = "SELECT * FROM timeslots";
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                TimeSlot timeSlot = extractTimeSlotFromResultSet(rs);
                loadDoctorTimeSlots(conn, timeSlot);
                timeSlots.add(timeSlot);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return timeSlots;
    }
    
    private TimeSlot extractTimeSlotFromResultSet(ResultSet rs) throws SQLException {
        TimeSlot timeSlot = new TimeSlot();
        timeSlot.setTimeslotId(rs.getInt("timeslot_id"));
        timeSlot.setSlotDate(rs.getDate("slot_date"));
        timeSlot.setStartTime(rs.getTime("start_time"));
        timeSlot.setEndTime(rs.getTime("end_time"));
        return timeSlot;
    }
    
    private void loadDoctorTimeSlots(Connection conn, TimeSlot timeSlot) throws SQLException {
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            String sql = "SELECT * FROM doctor_timeslots WHERE timeslot_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, timeSlot.getTimeslotId());
            rs = ps.executeQuery();
            
            while (rs.next()) {
                DoctorTimeSlot doctorTimeSlot = new DoctorTimeSlot();
                doctorTimeSlot.setDoctorId(rs.getInt("doctor_id"));
                doctorTimeSlot.setTimeslotId(rs.getInt("timeslot_id"));
                doctorTimeSlot.setAvailable(rs.getBoolean("is_available"));
                timeSlot.addDoctorTimeSlot(doctorTimeSlot);
            }
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
        }
    }
    
    public TimeSlot getTimeSlotById(int id) {
        TimeSlot timeSlot = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM timeslots WHERE timeslot_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                timeSlot = extractTimeSlotFromResultSet(rs);
                loadDoctorTimeSlots(conn, timeSlot);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return timeSlot;
    }
    
    public List<TimeSlot> getTimeSlotsByDoctor(int doctorId) {
        List<TimeSlot> timeSlots = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT t.* FROM timeslots t " +
                         "JOIN doctor_timeslots dt ON t.timeslot_id = dt.timeslot_id " +
                         "WHERE dt.doctor_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, doctorId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                TimeSlot timeSlot = extractTimeSlotFromResultSet(rs);
                loadDoctorTimeSlots(conn, timeSlot);
                timeSlots.add(timeSlot);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return timeSlots;
    }
    
    public List<TimeSlot> getAvailableTimeSlotsByDoctor(int doctorId, java.util.Date date) {
        List<TimeSlot> timeSlots = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT t.* FROM timeslots t " +
                         "JOIN doctor_timeslots dt ON t.timeslot_id = dt.timeslot_id " +
                         "WHERE dt.doctor_id = ? AND t.slot_date = ? AND dt.is_available = true";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, doctorId);
            ps.setDate(2, new Date(date.getTime()));
            rs = ps.executeQuery();
            
            while (rs.next()) {
                TimeSlot timeSlot = extractTimeSlotFromResultSet(rs);
                loadDoctorTimeSlots(conn, timeSlot);
                timeSlots.add(timeSlot);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return timeSlots;
    }
    
    public List<TimeSlot> getAvailableSlotsByDoctor(int doctorId, java.util.Date date) {
        return getAvailableTimeSlotsByDoctor(doctorId, date);
    }
    
    public boolean generateTimeSlots(int doctorId, java.util.Date date, java.time.LocalTime startTime, 
                                    java.time.LocalTime endTime, int slotDuration) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet generatedKeys = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            java.time.LocalTime currentTime = startTime;
            java.util.List<TimeSlot> timeSlots = new ArrayList<>();
            
            while (currentTime.plusMinutes(slotDuration).compareTo(endTime) <= 0) {
                TimeSlot slot = new TimeSlot();
                slot.setSlotDate(new java.sql.Date(date.getTime()));
                
                slot.setStartTime(java.sql.Time.valueOf(currentTime));
                slot.setEndTime(java.sql.Time.valueOf(currentTime.plusMinutes(slotDuration)));
                
                timeSlots.add(slot);
                currentTime = currentTime.plusMinutes(slotDuration);
            }
            
            String sql = "INSERT INTO timeslots (slot_date, start_time, end_time) VALUES (?, ?, ?)";
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            for (TimeSlot slot : timeSlots) {
                ps.setDate(1, new java.sql.Date(slot.getSlotDate().getTime()));
                ps.setTime(2, slot.getStartTime());
                ps.setTime(3, slot.getEndTime());
                ps.addBatch();
            }
            
            int[] rowsAffected = ps.executeBatch();
            generatedKeys = ps.getGeneratedKeys();
            
            List<Integer> timeSlotIds = new ArrayList<>();
            while (generatedKeys.next()) {
                timeSlotIds.add(generatedKeys.getInt(1));
            }
            
            if (timeSlotIds.size() == timeSlots.size()) {
                sql = "INSERT INTO doctor_timeslots (doctor_id, timeslot_id, is_available) VALUES (?, ?, true)";
                ps = conn.prepareStatement(sql);
                
                for (Integer timeSlotId : timeSlotIds) {
                    ps.setInt(1, doctorId);
                    ps.setInt(2, timeSlotId);
                    ps.addBatch();
                }
                
                rowsAffected = ps.executeBatch();
                
                if (rowsAffected.length == timeSlotIds.size()) {
                    conn.commit();
                    success = true;
                } else {
                    conn.rollback();
                }
            } else {
                conn.rollback();
            }
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
                if (generatedKeys != null) generatedKeys.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return success;
    }
    
    public boolean addTimeSlot(TimeSlot timeSlot, List<Integer> doctorIds) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet generatedKeys = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            String sql = "INSERT INTO timeslots (slot_date, start_time, end_time) VALUES (?, ?, ?)";
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setDate(1, new Date(timeSlot.getSlotDate().getTime()));
            ps.setTime(2, timeSlot.getStartTime());
            ps.setTime(3, timeSlot.getEndTime());
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int timeSlotId = generatedKeys.getInt(1);
                    timeSlot.setTimeslotId(timeSlotId);
                    
                    if (doctorIds != null && !doctorIds.isEmpty()) {
                        addDoctorTimeSlots(conn, timeSlotId, doctorIds);
                    }
                    
                    conn.commit();
                    success = true;
                }
            }
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
                if (generatedKeys != null) generatedKeys.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return success;
    }
    
    private void addDoctorTimeSlots(Connection conn, int timeSlotId, List<Integer> doctorIds) throws SQLException {
        PreparedStatement ps = null;
        
        try {
            String sql = "INSERT INTO doctor_timeslots (doctor_id, timeslot_id, is_available) VALUES (?, ?, true)";
            ps = conn.prepareStatement(sql);
            
            for (Integer doctorId : doctorIds) {
                ps.setInt(1, doctorId);
                ps.setInt(2, timeSlotId);
                ps.addBatch();
            }
            
            ps.executeBatch();
        } finally {
            if (ps != null) ps.close();
        }
    }
    
    public boolean updateTimeSlotAvailability(int doctorId, int timeSlotId, boolean isAvailable) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE doctor_timeslots SET is_available = ? WHERE doctor_id = ? AND timeslot_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setBoolean(1, isAvailable);
            ps.setInt(2, doctorId);
            ps.setInt(3, timeSlotId);
            
            int rowsAffected = ps.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return success;
    }
    
    public boolean deleteTimeSlot(int id) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            String sql = "DELETE FROM doctor_timeslots WHERE timeslot_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
            ps.close();
            
            sql = "DELETE FROM timeslots WHERE timeslot_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            
            int rowsAffected = ps.executeUpdate();
            conn.commit();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return success;
    }
    
    public boolean batchAddTimeSlots(List<TimeSlot> timeSlots, int doctorId) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            String sql = "INSERT INTO timeslots (slot_date, start_time, end_time) VALUES (?, ?, ?)";
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            for (TimeSlot slot : timeSlots) {
                ps.setDate(1, new Date(slot.getSlotDate().getTime()));
                ps.setTime(2, slot.getStartTime());
                ps.setTime(3, slot.getEndTime());
                ps.addBatch();
            }
            
            int[] results = ps.executeBatch();
            ResultSet generatedKeys = ps.getGeneratedKeys();
            int index = 0;
            
            while (generatedKeys.next() && index < results.length && results[index] > 0) {
                int timeSlotId = generatedKeys.getInt(1);
                
                PreparedStatement psRel = conn.prepareStatement(
                        "INSERT INTO doctor_timeslots (doctor_id, timeslot_id, is_available) VALUES (?, ?, true)");
                psRel.setInt(1, doctorId);
                psRel.setInt(2, timeSlotId);
                psRel.executeUpdate();
                psRel.close();
                
                index++;
            }
            
            conn.commit();
            success = true;
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return success;
    }
}
