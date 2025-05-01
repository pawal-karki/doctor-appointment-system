package controller.admin;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import dao.DepartmentDAO;
import dao.DoctorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Department;
import model.Doctor;
import model.User;

@WebServlet("/admin/doctors")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class AdminDoctorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DoctorDAO doctorDAO;
    private DepartmentDAO departmentDAO;
    
    public void init() {
        doctorDAO = new DoctorDAO();
        departmentDAO = new DepartmentDAO();
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
            listDoctors(request, response);
        } else if (action.equals("add")) {
            showAddForm(request, response);
        } else if (action.equals("edit")) {
            showEditForm(request, response);
        } else if (action.equals("delete")) {
            deleteDoctor(request, response);
        }
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
        
        if (action != null && action.equals("add")) {
            addDoctor(request, response);
        } else if (action != null && action.equals("edit")) {
            updateDoctor(request, response);
        }
    }
    
    private void listDoctors(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Doctor> doctors = doctorDAO.getAllDoctors();
        List<Department> departments = departmentDAO.getAllDepartments();
        
        // Create a map of department IDs to department objects
        Map<Integer, Department> departmentMap = new HashMap<>();
        for (Department department : departments) {
            departmentMap.put(department.getId(), department);
        }
        
        request.setAttribute("doctors", doctors);
        request.setAttribute("departmentMap", departmentMap);
        request.getRequestDispatcher("/WEB-INF/views/admin/doctors.jsp").forward(request, response);
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Department> departments = departmentDAO.getAllDepartments();
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("/WEB-INF/views/admin/add-doctor.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int doctorId = Integer.parseInt(request.getParameter("id"));
        Doctor doctor = doctorDAO.getDoctorById(doctorId);
        List<Department> departments = departmentDAO.getAllDepartments();
        
        request.setAttribute("doctor", doctor);
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("/WEB-INF/views/admin/edit-doctor.jsp").forward(request, response);
    }
    
    private void addDoctor(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String specialization = request.getParameter("specialization");
        String qualification = request.getParameter("qualification");
        String experience = request.getParameter("experience");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));
        
        // Handle image upload
        Part filePart = request.getPart("image");
        String fileName = getSubmittedFileName(filePart);
        String imageUrl = "";
        
        if (fileName != null && !fileName.isEmpty()) {
            String uploadDir = getServletContext().getRealPath("/uploads/doctors");
            File uploadDirFile = new File(uploadDir);
            if (!uploadDirFile.exists()) {
                uploadDirFile.mkdirs();
            }
            
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
            String filePath = uploadDir + File.separator + uniqueFileName;
            filePart.write(filePath);
            
            imageUrl = "uploads/doctors/" + uniqueFileName;
        }
        
        Doctor doctor = new Doctor();
        doctor.setName(name);
        doctor.setSpecialization(specialization);
        doctor.setQualification(qualification);
        doctor.setExperience(experience);
        doctor.setEmail(email);
        doctor.setPhone(phone);
        doctor.setImageUrl(imageUrl);
        doctor.setDepartmentId(departmentId);
        
        boolean success = doctorDAO.addDoctor(doctor);
        
        if (success) {
            request.setAttribute("successMessage", "Doctor added successfully");
            response.sendRedirect(request.getContextPath() + "/admin/doctors");
        } else {
            request.setAttribute("errorMessage", "Failed to add doctor");
            showAddForm(request, response);
        }
    }
    
    private void updateDoctor(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int doctorId = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String specialization = request.getParameter("specialization");
        String qualification = request.getParameter("qualification");
        String experience = request.getParameter("experience");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));
        
        Doctor doctor = doctorDAO.getDoctorById(doctorId);
        String imageUrl = doctor.getImageUrl();
        
        // Handle image upload if a new image is provided
        Part filePart = request.getPart("image");
        String fileName = getSubmittedFileName(filePart);
        
        if (fileName != null && !fileName.isEmpty()) {
            String uploadDir = getServletContext().getRealPath("/uploads/doctors");
            File uploadDirFile = new File(uploadDir);
            if (!uploadDirFile.exists()) {
                uploadDirFile.mkdirs();
            }
            
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
            String filePath = uploadDir + File.separator + uniqueFileName;
            filePart.write(filePath);
            
            imageUrl = "uploads/doctors/" + uniqueFileName;
        }
        
        doctor.setName(name);
        doctor.setSpecialization(specialization);
        doctor.setQualification(qualification);
        doctor.setExperience(experience);
        doctor.setEmail(email);
        doctor.setPhone(phone);
        doctor.setImageUrl(imageUrl);
        doctor.setDepartmentId(departmentId);
        
        boolean success = doctorDAO.updateDoctor(doctor);
        
        if (success) {
            request.setAttribute("successMessage", "Doctor updated successfully");
            response.sendRedirect(request.getContextPath() + "/admin/doctors");
        } else {
            request.setAttribute("errorMessage", "Failed to update doctor");
            showEditForm(request, response);
        }
    }
    
    private void deleteDoctor(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int doctorId = Integer.parseInt(request.getParameter("id"));
        
        boolean success = doctorDAO.deleteDoctor(doctorId);
        
        if (success) {
            request.setAttribute("successMessage", "Doctor deleted successfully");
        } else {
            request.setAttribute("errorMessage", "Failed to delete doctor");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/doctors");
    }
    
    private String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                return fileName.substring(fileName.lastIndexOf('/') + 1).substring(fileName.lastIndexOf('\\') + 1);
            }
        }
        return null;
    }
}