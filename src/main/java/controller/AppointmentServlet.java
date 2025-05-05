package controller;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.AppointmentDAO;
import dao.DoctorDAO;
import dao.TimeSlotDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Appointment;
import model.Doctor;
import model.TimeSlot;
import model.User;

@WebServlet("/appointments")
public class AppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AppointmentServlet.class.getName());
    
    private AppointmentDAO appointmentDAO;
    private DoctorDAO doctorDAO;
    private UserDAO userDAO;
    private TimeSlotDAO timeSlotDAO;
    
    public void init() {
        appointmentDAO = new AppointmentDAO();
        doctorDAO = new DoctorDAO();
        userDAO = new UserDAO();
        timeSlotDAO = new TimeSlotDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        
        if (action == null) {
            listAppointments(request, response, user);
        } else if (action.equals("book")) {
            showBookingForm(request, response, user);
        } else if (action.equals("view")) {
            viewAppointment(request, response, user);
        } else if (action.equals("cancel")) {
            cancelAppointment(request, response, user);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        
        if (action != null && action.equals("book")) {
            bookAppointment(request, response, user);
        }
    }
    
    private void listAppointments(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        LOGGER.log(Level.INFO, "Listing appointments for user: {0}", user.getName());
        
        try {
            List<Appointment> appointments = appointmentDAO.getAppointmentsByUser(user.getUserId());
            Map<Integer, Doctor> doctorMap = new HashMap<>();
            Map<Integer, TimeSlot> timeSlots = new HashMap<>();

            LOGGER.log(Level.INFO, "Retrieved {0} appointments for user ID: {1}", new Object[]{appointments.size(), user.getUserId()});
            
            // Create a map of doctors and timeslots for easier lookup in JSP
            for (Appointment appointment : appointments) {
                // Add doctor to map if not already there
                if (!doctorMap.containsKey(appointment.getDoctorId())) {
                    Doctor doctor = doctorDAO.getDoctorById(appointment.getDoctorId());
                    // Log if doctor retrieval has issues
                    if (doctor == null) {
                        LOGGER.log(Level.WARNING, "Doctor not found for ID: {0}", appointment.getDoctorId());
                    }
                    doctorMap.put(appointment.getDoctorId(), doctor);
                }
                
                // Add timeslot to map if not already there
                if (!timeSlots.containsKey(appointment.getTimeSlot())) {
                    TimeSlot timeSlot = timeSlotDAO.getTimeSlotById(appointment.getTimeSlot());
                    if (timeSlot != null) {
                        timeSlots.put(appointment.getTimeSlot(), timeSlot);
                    }
                }
            }
            
            request.setAttribute("appointments", appointments);
            request.setAttribute("doctorMap", doctorMap);
            request.setAttribute("timeSlots", timeSlots);
            request.getRequestDispatcher("/WEB-INF/views/my-appointments.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in listAppointments", e);
            request.setAttribute("errorMessage", "An error occurred while retrieving your appointments.");
            request.getRequestDispatcher("/WEB-INF/views/my-appointments.jsp").forward(request, response);
        }
    }
    
    private void viewAppointment(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        int appointmentId = Integer.parseInt(request.getParameter("id"));
        Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
        
        // Check if the appointment belongs to the user
        if (appointment.getUserId() != user.getUserId() && !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/appointments");
            return;
        }
        
        Doctor doctor = doctorDAO.getDoctorById(appointment.getDoctorId());
        TimeSlot timeSlot = timeSlotDAO.getTimeSlotById(appointment.getTimeSlot());
        
        request.setAttribute("appointment", appointment);
        request.setAttribute("doctor", doctor);
        request.setAttribute("timeSlot", timeSlot);
        request.getRequestDispatcher("/WEB-INF/views/appointment-details.jsp").forward(request, response);
    }
    
    private void showBookingForm(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        try {
            String doctorIdStr = request.getParameter("doctorId");
            String dateStr = request.getParameter("date");
            String slotIdStr = request.getParameter("slotId");
            
            // Check for null parameters and provide default error handling
            if (doctorIdStr == null || dateStr == null || slotIdStr == null) {
                request.setAttribute("errorMessage", "Missing required parameters for booking.");
                listAppointments(request, response, user);
                return;
            }
            
            int doctorId = Integer.parseInt(doctorIdStr);
            int timeSlotId = Integer.parseInt(slotIdStr);
            
            Doctor doctor = doctorDAO.getDoctorById(doctorId);
            TimeSlot timeSlot = timeSlotDAO.getTimeSlotById(timeSlotId);
            
            if (doctor == null || timeSlot == null) {
                request.setAttribute("errorMessage", "Doctor or time slot not found.");
                listAppointments(request, response, user);
                return;
            }
            
            request.setAttribute("doctor", doctor);
            request.setAttribute("timeSlot", timeSlot);
            request.setAttribute("date", dateStr);
            
            request.getRequestDispatcher("/WEB-INF/views/book-appointment.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Error parsing parameters", e);
            request.setAttribute("errorMessage", "Invalid parameters for booking.");
            listAppointments(request, response, user);
        }
    }
    
    private void bookAppointment(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        try {
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            int timeSlotId = Integer.parseInt(request.getParameter("timeSlotId"));
            String notes = request.getParameter("notes");
            String dateStr = request.getParameter("date");
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date appointmentDate = sdf.parse(dateStr);
            
            // Check if the time slot is available
            TimeSlot timeSlot = timeSlotDAO.getTimeSlotById(timeSlotId);
            boolean isAvailable = false;
            
            if (timeSlot != null && timeSlot.getDoctorTimeSlots() != null) {
                for (int i = 0; i < timeSlot.getDoctorTimeSlots().size(); i++) {
                    if (timeSlot.getDoctorTimeSlots().get(i).getDoctorId() == doctorId && 
                        timeSlot.getDoctorTimeSlots().get(i).isAvailable()) {
                        isAvailable = true;
                        break;
                    }
                }
            }
            
            if (!isAvailable) {
                request.setAttribute("errorMessage", "This time slot is no longer available.");
                showBookingForm(request, response, user);
                return;
            }
            
            // Create and save appointment
            Appointment appointment = new Appointment();
            appointment.setUserId(user.getUserId());
            appointment.setDoctorId(doctorId);
            appointment.setAppointmentDate(appointmentDate);
            appointment.setTimeSlot(timeSlotId);
            appointment.setStatus("pending");
            appointment.setNote(notes);
            
            boolean success = appointmentDAO.bookAppointment(appointment);
            
            if (success) {
                request.setAttribute("successMessage", "Appointment booked successfully!");
                listAppointments(request, response, user);
            } else {
                request.setAttribute("errorMessage", "Failed to book appointment. Please try again.");
                showBookingForm(request, response, user);
            }
        } catch (ParseException e) {
            LOGGER.log(Level.SEVERE, "Error parsing date", e);
            request.setAttribute("errorMessage", "Invalid date format.");
            showBookingForm(request, response, user);
        }
    }
    
    private void cancelAppointment(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        int appointmentId = Integer.parseInt(request.getParameter("id"));
        Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
        
        // Check if the appointment belongs to the user
        if (appointment.getUserId() != user.getUserId() && !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/appointments");
            return;
        }
        
        boolean success = appointmentDAO.cancelAppointment(appointmentId);
        
        if (success) {
            request.setAttribute("successMessage", "Appointment cancelled successfully!");
        } else {
            request.setAttribute("errorMessage", "Failed to cancel appointment. Please try again.");
        }
        
        listAppointments(request, response, user);
    }
}
