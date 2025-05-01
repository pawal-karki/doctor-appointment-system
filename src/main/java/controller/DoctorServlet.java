package controller;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalTime;
import java.util.Date;
import java.util.List;
import java.util.logging.Logger;

import dao.DoctorDAO;
import dao.TimeSlotDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Doctor;
import model.TimeSlot;

@WebServlet("/doctors")
public class DoctorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(DoctorServlet.class.getName());
    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    private DoctorDAO doctorDAO;
    private TimeSlotDAO timeSlotDAO;

    public void init() {
        doctorDAO = new DoctorDAO();
        timeSlotDAO = new TimeSlotDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            listDoctors(request, response);
        } else if (action.equals("view")) {
            viewDoctor(request, response);
        }
    }

    private void listDoctors(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchTerm = request.getParameter("search");
        String specialization = request.getParameter("specialization");

        List<Doctor> doctors;

        // Get all distinct specializations for the filter dropdown
        List<String> specializations = doctorDAO.getAllSpecializations();
        request.setAttribute("specializations", specializations);

        // Apply filters if provided
        if ((searchTerm != null && !searchTerm.isEmpty()) ||
                (specialization != null && !specialization.isEmpty())) {
            doctors = doctorDAO.searchDoctors(searchTerm, specialization);
        } else {
            doctors = doctorDAO.getAllDoctors();
        }

        request.setAttribute("doctors", doctors);
        request.getRequestDispatcher("/WEB-INF/views/doctors.jsp").forward(request, response);
    }

    private void viewDoctor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int doctorId = Integer.parseInt(request.getParameter("id"));
            Doctor doctor = doctorDAO.getDoctorById(doctorId);

            if (doctor == null) {
                logger.warning("Doctor not found with ID: " + doctorId);
                response.sendRedirect(request.getContextPath() + "/doctors");
                return;
            }

            // Get available slots for today
            Date today = new Date();
            List<TimeSlot> availableSlots = timeSlotDAO.getAvailableSlotsByDoctor(doctorId, today);

            // If no slots are available for today, automatically generate some
            if (availableSlots.isEmpty()) {
                logger.info("No slots found for doctor " + doctorId + " for today. Generating default slots.");

                // Default time range from 9 AM to 5 PM with 30-minute slots
                LocalTime startTime = LocalTime.of(9, 0); // 9:00 AM
                LocalTime endTime = LocalTime.of(17, 0);  // 5:00 PM
                int slotDuration = 30; // 30 minutes per slot

                boolean success = timeSlotDAO.generateTimeSlots(doctorId, today, startTime, endTime, slotDuration);

                if (success) {
                    logger.info("Successfully generated time slots for doctor " + doctorId + " for today");
                    // Get the newly generated slots
                    availableSlots = timeSlotDAO.getAvailableSlotsByDoctor(doctorId, today);
                } else {
                    logger.warning("Failed to generate time slots for doctor " + doctorId + " for today");
                }
            }

            logger.info("Found " + availableSlots.size() + " available slots for doctor " + doctorId + " on " + today);

            request.setAttribute("doctor", doctor);
            request.setAttribute("availableSlots", availableSlots);
            request.setAttribute("selectedDate", today);
            request.setAttribute("now", new Date());

            request.getRequestDispatcher("/WEB-INF/views/doctor-details.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            logger.severe("Invalid doctor ID format: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/doctors");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action != null && action.equals("getSlots")) {
            getAvailableSlots(request, response);
        }
    }

    private void getAvailableSlots(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

        try {
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String dateStr = request.getParameter("date");

            logger.info("Getting slots for doctor " + doctorId + " on date " + dateStr);

            Date date = dateFormat.parse(dateStr);
            List<TimeSlot> availableSlots = timeSlotDAO.getAvailableSlotsByDoctor(doctorId, date);

            // If no slots are available for this date, automatically generate some
            if (availableSlots.isEmpty()) {
                logger.info("No slots found for doctor " + doctorId + " on date " + dateStr + ". Generating default slots.");

                // Default time range from 9 AM to 5 PM with 30-minute slots
                LocalTime startTime = LocalTime.of(9, 0); // 9:00 AM
                LocalTime endTime = LocalTime.of(17, 0);  // 5:00 PM
                int slotDuration = 30; // 30 minutes per slot

                boolean success = timeSlotDAO.generateTimeSlots(doctorId, date, startTime, endTime, slotDuration);

                if (success) {
                    logger.info("Successfully generated time slots for doctor " + doctorId + " on date " + dateStr);
                    // Get the newly generated slots
                    availableSlots = timeSlotDAO.getAvailableSlotsByDoctor(doctorId, date);
                } else {
                    logger.warning("Failed to generate time slots for doctor " + doctorId + " on date " + dateStr);
                }
            }

            Doctor doctor = doctorDAO.getDoctorById(doctorId);

            logger.info("Found " + availableSlots.size() + " available slots");

            request.setAttribute("doctor", doctor);
            request.setAttribute("availableSlots", availableSlots);
            request.setAttribute("selectedDate", date);
            request.setAttribute("now", new Date());

            request.getRequestDispatcher("/WEB-INF/views/doctor-details.jsp").forward(request, response);
        } catch (ParseException | NumberFormatException e) {
            logger.severe("Error processing slot request: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/doctors");
        }
    }
}