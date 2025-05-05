package controller;

import java.io.IOException;
import java.util.List;

import dao.DoctorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Doctor;

@WebServlet("/about")
public class AboutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DoctorDAO doctorDAO;
    
    @Override
    public void init() {
        doctorDAO = new DoctorDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get 3 head doctors instead of 4
        List<Doctor> headDoctors = doctorDAO.getHeadDoctors(3);
        request.setAttribute("headDoctors", headDoctors);
        
        request.getRequestDispatcher("/WEB-INF/views/about.jsp").forward(request, response);
    }
}
