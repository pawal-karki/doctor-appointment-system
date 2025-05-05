package controller.admin;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import dao.AppointmentDAO;
import dao.DepartmentDAO;
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
import model.Department;
import model.Doctor;
import model.TimeSlot;
import model.User;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentDAO appointmentDAO;
    private DepartmentDAO departmentDAO;
    private DoctorDAO doctorDAO;
    private UserDAO userDAO;
    private TimeSlotDAO timeSlotDAO;
    
    public void init() {
        appointmentDAO = new AppointmentDAO();
        departmentDAO = new DepartmentDAO();
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
        
        // Get dashboard data
        List<Appointment> todayAppointments = appointmentDAO.getTodayAppointments();
        List<Appointment> futureAppointments = appointmentDAO.getFutureAppointments();
        List<Department> departments = departmentDAO.getAllDepartments();
        List<Doctor> doctors = doctorDAO.getAllDoctors();
        List<User> patients = userDAO.getAllPatients();
        
        // Create maps for easy lookup
        Map<Integer, User> patientMap = new HashMap<>();
        for (User patient : patients) {
            patientMap.put(patient.getId(), patient);
        }
        
        Map<Integer, Doctor> doctorMap = new HashMap<>();
        for (Doctor doctor : doctors) {
            doctorMap.put(doctor.getId(), doctor);
        }
        
        // Create timeslot map for appointments
        Map<Integer, TimeSlot> timeSlotsMap = new HashMap<>();
        for (Appointment appointment : todayAppointments) {
            if (!timeSlotsMap.containsKey(appointment.getTimeSlot())) {
                TimeSlot timeSlot = timeSlotDAO.getTimeSlotById(appointment.getTimeSlot());
                if (timeSlot != null) {
                    timeSlotsMap.put(appointment.getTimeSlot(), timeSlot);
                }
            }
        }
        
        for (Appointment appointment : futureAppointments) {
            if (!timeSlotsMap.containsKey(appointment.getTimeSlot())) {
                TimeSlot timeSlot = timeSlotDAO.getTimeSlotById(appointment.getTimeSlot());
                if (timeSlot != null) {
                    timeSlotsMap.put(appointment.getTimeSlot(), timeSlot);
                }
            }
        }
        
        // Set attributes for the JSP
        request.setAttribute("todayAppointments", todayAppointments);
        request.setAttribute("futureAppointments", futureAppointments);
        request.setAttribute("departmentCount", departments.size());
        request.setAttribute("doctorCount", doctors.size());
        request.setAttribute("patientCount", patients.size());
        request.setAttribute("patientMap", patientMap);
        request.setAttribute("doctorMap", doctorMap);
        request.setAttribute("timeSlotsMap", timeSlotsMap);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}
