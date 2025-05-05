package controller.admin;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalTime;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.DoctorDAO;
import dao.TimeSlotDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Doctor;
import model.TimeSlot;
import model.User;

@WebServlet("/admin/timeslots")
public class AdminTimeSlotServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AdminTimeSlotServlet.class.getName());
    
    private TimeSlotDAO timeSlotDAO;
    private DoctorDAO doctorDAO;
    
    public void init() {
        timeSlotDAO = new TimeSlotDAO();
        doctorDAO = new DoctorDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get all doctors for the dropdown
        List<Doctor> doctors = doctorDAO.getAllDoctors();
        request.setAttribute("doctors", doctors);
        
        // Create a map of doctors for easy lookup
        Map<Integer, Doctor> doctorMap = new HashMap<>();
        for (Doctor doctor : doctors) {
            doctorMap.put(doctor.getId(), doctor);
        }
        request.setAttribute("doctorMap", doctorMap);
        
        // Get all time slots
        List<TimeSlot> timeSlots = timeSlotDAO.getAllTimeSlots();
        request.setAttribute("timeSlots", timeSlots);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/manage-timeslots.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            deleteTimeSlot(request, response);
        } else {
            generateTimeSlots(request, response);
        }
    }
    
    private void generateTimeSlots(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String dateStr = request.getParameter("date");
            String startTimeStr = request.getParameter("startTime");
            String endTimeStr = request.getParameter("endTime");
            int slotDuration = Integer.parseInt(request.getParameter("slotDuration"));
            
            // Parse the date
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date date = dateFormat.parse(dateStr);
            
            // Parse start and end times
            LocalTime startTime = LocalTime.parse(startTimeStr);
            LocalTime endTime = LocalTime.parse(endTimeStr);
            
            // Generate time slots
            boolean success = timeSlotDAO.generateTimeSlots(doctorId, date, startTime, endTime, slotDuration);
            
            if (success) {
                request.setAttribute("successMessage", "Time slots generated successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to generate time slots");
            }
        } catch (ParseException e) {
            LOGGER.log(Level.SEVERE, "Error parsing date/time", e);
            request.setAttribute("errorMessage", "Invalid date or time format");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error generating time slots", e);
            request.setAttribute("errorMessage", "An error occurred while generating time slots");
        }
        
        doGet(request, response);
    }
    
    private void deleteTimeSlot(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int slotId = Integer.parseInt(request.getParameter("slotId"));
            
            boolean success = timeSlotDAO.deleteTimeSlot(slotId);
            
            if (success) {
                request.setAttribute("successMessage", "Time slot deleted successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to delete time slot");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error deleting time slot", e);
            request.setAttribute("errorMessage", "An error occurred while deleting the time slot");
        }
        
        doGet(request, response);
    }
} 