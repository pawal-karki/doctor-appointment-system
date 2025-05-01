package controller.admin;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import util.EmailUtil;


@WebServlet("/admin/appointments")
public class AdminAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
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
        User user = (User) session.getAttribute("user");

        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            listAppointments(request, response);
        } else if (action.equals("view")) {
            viewAppointment(request, response);
        } else if (action.equals("updateStatus")) {
            updateAppointmentStatus(request, response);
        }
    }

    private void listAppointments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Appointment> appointments = appointmentDAO.getAllAppointments();

        // Create maps for easy lookup
        Map<Integer, User> patientMap = new HashMap<>();
        Map<Integer, Doctor> doctorMap = new HashMap<>();
        Map<Integer, TimeSlot> timeSlots = new HashMap<>();

        // Populate maps
        for (Appointment appointment : appointments) {
            User patient = userDAO.getUserById(appointment.getUserId());
            if (patient != null) {
                patientMap.put(patient.getId(), patient);
            }

            Doctor doctor = doctorDAO.getDoctorById(appointment.getDoctorId());
            if (doctor != null) {
                doctorMap.put(doctor.getId(), doctor);
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
        request.setAttribute("patientMap", patientMap);
        request.setAttribute("doctorMap", doctorMap);
        request.setAttribute("timeSlots", timeSlots);

        request.getRequestDispatcher("/WEB-INF/views/admin/appointments.jsp").forward(request, response);
    }

    private void viewAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int appointmentId = Integer.parseInt(request.getParameter("id"));
        Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);

        User patient = userDAO.getUserById(appointment.getUserId());
        Doctor doctor = doctorDAO.getDoctorById(appointment.getDoctorId());
        TimeSlot timeSlot = timeSlotDAO.getTimeSlotById(appointment.getTimeSlot());

        request.setAttribute("appointment", appointment);
        request.setAttribute("patient", patient);
        request.setAttribute("doctor", doctor);
        request.setAttribute("timeSlot", timeSlot);

        request.getRequestDispatcher("/WEB-INF/views/admin/appointment-details.jsp").forward(request, response);
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

        if (action != null && action.equals("updateStatus")) {
            updateAppointmentStatus(request, response);
        }
    }

    private void updateAppointmentStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int appointmentId = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");

        boolean success = appointmentDAO.updateAppointmentStatus(appointmentId, status);

        if (success) {
            request.setAttribute("successMessage", "Appointment status updated successfully");

            // Get appointment details for email notifications
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            User patient = userDAO.getUserById(appointment.getUserId());
            Doctor doctor = doctorDAO.getDoctorById(appointment.getDoctorId());
            TimeSlot timeSlot = timeSlotDAO.getTimeSlotById(appointment.getTimeSlot());

            if (patient != null && doctor != null && timeSlot != null) {
                // Format the date and time
                String formattedDate = new SimpleDateFormat("MMMM d, yyyy").format(appointment.getAppointmentDate());
                String timeSlotStr = timeSlot.getStartTime() + " - " + timeSlot.getEndTime();

                boolean emailSent = false;
                String emailType = "";

                // Send appropriate email based on status
                if ("confirmed".equalsIgnoreCase(status)) {
                    emailSent = EmailUtil.sendAppointmentConfirmation(
                            patient.getEmail(),
                            doctor.getName(),
                            formattedDate,
                            timeSlotStr
                    );
                    emailType = "confirmation";
                } else if ("cancelled".equalsIgnoreCase(status)) {
                    emailSent = EmailUtil.sendAppointmentCancellation(
                            patient.getEmail(),
                            doctor.getName(),
                            formattedDate,
                            timeSlotStr
                    );
                    emailType = "cancellation";
                }

                // Set warning message if email failed
                if (!emailSent && !emailType.isEmpty()) {
                    request.setAttribute("warningMessage",
                            "Appointment status updated but failed to send " + emailType + " email to patient");
                }
            }
        } else {
            request.setAttribute("errorMessage", "Failed to update appointment status");
        }

        viewAppointment(request, response);
    }
}
