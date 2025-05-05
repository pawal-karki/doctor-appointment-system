package controller;

import java.io.IOException;
import java.util.List;

import dao.DepartmentDAO;
import dao.DoctorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Department;
import model.Doctor;

@WebServlet("/departments")
public class DepartmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DepartmentDAO departmentDAO;
    private DoctorDAO doctorDAO;
    
    public void init() {
        departmentDAO = new DepartmentDAO();
        doctorDAO = new DoctorDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            listDepartments(request, response);
        } else if (action.equals("view")) {
            viewDepartment(request, response);
        } else if (action.equals("search")) {
            searchDepartments(request, response);
        }
    }
    
    private void listDepartments(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Department> departments = departmentDAO.getAllDepartments();
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("/WEB-INF/views/departments.jsp").forward(request, response);
    }
    
    private void viewDepartment(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int departmentId = Integer.parseInt(request.getParameter("id"));
        Department department = departmentDAO.getDepartmentById(departmentId);
        List<Doctor> doctors = doctorDAO.getDoctorsByDepartment(departmentId);
        
        request.setAttribute("department", department);
        request.setAttribute("doctors", doctors);
        request.getRequestDispatcher("/WEB-INF/views/department-details.jsp").forward(request, response);
    }
    
    private void searchDepartments(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Department> departments = departmentDAO.searchDepartments(keyword);
        
        request.setAttribute("departments", departments);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/WEB-INF/views/departments.jsp").forward(request, response);
    }
}
