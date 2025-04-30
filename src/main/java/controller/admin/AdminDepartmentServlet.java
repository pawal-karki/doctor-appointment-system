package controller.admin;

import java.io.File;
import java.io.IOException;
import java.util.List;

import dao.DepartmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Department;
import model.User;

@WebServlet("/admin/departments")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 10,  // 10 MB
        maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class AdminDepartmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DepartmentDAO departmentDAO;

    public void init() {
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
            listDepartments(request, response);
        } else if (action.equals("add")) {
            showAddForm(request, response);
        } else if (action.equals("edit")) {
            showEditForm(request, response);
        } else if (action.equals("delete")) {
            deleteDepartment(request, response);
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
            addDepartment(request, response);
        } else if (action != null && action.equals("edit")) {
            updateDepartment(request, response);
        }
    }

    private void listDepartments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Department> departments = departmentDAO.getAllDepartments();
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("/WEB-INF/views/admin/departments.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/admin/add-department.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int departmentId = Integer.parseInt(request.getParameter("id"));
        Department department = departmentDAO.getDepartmentById(departmentId);
        request.setAttribute("department", department);
        request.getRequestDispatcher("/WEB-INF/views/admin/edit-department.jsp").forward(request, response);
    }

    private void addDepartment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");

        // Handle image upload
        Part filePart = request.getPart("image");
        String fileName = getSubmittedFileName(filePart);
        String imageUrl = "";

        if (fileName != null && !fileName.isEmpty()) {
            String uploadDir = getServletContext().getRealPath("/uploads/departments");
            File uploadDirFile = new File(uploadDir);
            if (!uploadDirFile.exists()) {
                uploadDirFile.mkdirs();
            }

            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
            String filePath = uploadDir + File.separator + uniqueFileName;
            filePart.write(filePath);

            imageUrl = "uploads/departments/" + uniqueFileName;
        }

        Department department = new Department();
        department.setName(name);
        department.setDescription(description);
        department.setImageUrl(imageUrl);

        boolean success = departmentDAO.addDepartment(department);

        if (success) {
            request.setAttribute("successMessage", "Department added successfully");
            response.sendRedirect(request.getContextPath() + "/admin/departments");
        } else {
            request.setAttribute("errorMessage", "Failed to add department");
            showAddForm(request, response);
        }
    }

    private void updateDepartment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int departmentId = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");

        Department department = departmentDAO.getDepartmentById(departmentId);
        String imageUrl = department.getImageUrl();

        // Handle image upload if a new image is provided
        Part filePart = request.getPart("image");
        String fileName = getSubmittedFileName(filePart);

        if (fileName != null && !fileName.isEmpty()) {
            String uploadDir = getServletContext().getRealPath("/uploads/departments");
            File uploadDirFile = new File(uploadDir);
            if (!uploadDirFile.exists()) {
                uploadDirFile.mkdirs();
            }

            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
            String filePath = uploadDir + File.separator + uniqueFileName;
            filePart.write(filePath);

            imageUrl = "uploads/departments/" + uniqueFileName;
        }

        department.setName(name);
        department.setDescription(description);
        department.setImageUrl(imageUrl);

        boolean success = departmentDAO.updateDepartment(department);

        if (success) {
            request.setAttribute("successMessage", "Department updated successfully");
            response.sendRedirect(request.getContextPath() + "/admin/departments");
        } else {
            request.setAttribute("errorMessage", "Failed to update department");
            showEditForm(request, response);
        }
    }

    private void deleteDepartment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int departmentId = Integer.parseInt(request.getParameter("id"));

        boolean success = departmentDAO.deleteDepartment(departmentId);

        if (success) {
            request.setAttribute("successMessage", "Department deleted successfully");
        } else {
            request.setAttribute("errorMessage", "Failed to delete department");
        }

        response.sendRedirect(request.getContextPath() + "/admin/departments");
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