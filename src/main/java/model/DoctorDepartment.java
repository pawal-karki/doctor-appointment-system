package model;

public class DoctorDepartment {
	private int id;
    private int doctorId;
    private int departmentId;
    
    public DoctorDepartment() {
    	
    }

	public DoctorDepartment(int id, int doctorId, int departmentId) {
		super();
		this.id = id;
		this.doctorId = doctorId;
		this.departmentId = departmentId;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getDoctorId() {
		return doctorId;
	}

	public void setDoctorId(int doctorId) {
		this.doctorId = doctorId;
	}

	public int getDepartmentId() {
		return departmentId;
	}

	public void setDepartmentId(int departmentId) {
		this.departmentId = departmentId;
	}
    
    
}
