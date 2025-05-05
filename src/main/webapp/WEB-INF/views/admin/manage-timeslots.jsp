<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Time Slots - Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
    --primary-color: #3b82f6;
    --primary-hover: #2563eb;
    --secondary-color: #64748b;
    --background-color: #f9fafb;
    --text-color: #1e293b;
    --error-bg: #fee2e2;
    --error-text: #dc2626;
    --success-bg: #dcfce7;
    --success-text: #16a34a;
    --border-radius: 0.5rem;
    --transition: all 0.2s ease;
    --card-bg: #fff;
    --card-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
    --sidebar-width: 250px;
    --input-border: #e2e8f0;
    --input-focus: rgba(59, 130, 246, 0.2);
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: "Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    line-height: 1.6;
    color: var(--text-color);
    background-color: var(--background-color);
    min-height: 100vh;
}

.admin-layout {
    display: flex;
    min-height: 100vh;
}

.admin-content {
    flex: 1;
    margin-left: var(--sidebar-width);
    padding: 2rem;
}

.content-header {
    margin-bottom: 2rem;
}

.content-header h1 {
    font-size: 1.875rem;
    font-weight: 600;
    color: var(--text-color);
    letter-spacing: -0.025em;
}

.alert {
    padding: 1rem;
    border-radius: var(--border-radius);
    margin-bottom: 1.5rem;
    display: flex;
    align-items: center;
}

.alert-success {
    background-color: var(--success-bg);
    color: var(--success-text);
    border-left: 4px solid var(--success-text);
}

.alert-danger {
    background-color: var(--error-bg);
    color: var(--error-text);
    border-left: 4px solid var(--error-text);
}

.card {
    background-color: var(--card-bg);
    border-radius: var(--border-radius);
    box-shadow: var(--card-shadow);
    padding: 1.5rem;
    margin-bottom: 2rem;
    border: 1px solid rgba(0, 0, 0, 0.05);
}

.card h2 {
    font-size: 1.25rem;
    font-weight: 600;
    margin-bottom: 1.5rem;
    color: var(--text-color);
}

.form-group {
    margin-bottom: 1.5rem;
}

.form-group label {
    display: block;
    margin-bottom: 0.5rem;
    font-weight: 500;
    color: var(--text-color);
    font-size: 0.875rem;
}

.form-control {
    width: 100%;
    padding: 0.625rem;
    border: 1px solid var(--input-border);
    border-radius: var(--border-radius);
    font-size: 0.875rem;
    transition: var(--transition);
    background-color: white;
}

.form-control:focus {
    outline: none;
    border-color: var(--primary-color);
    box-shadow: 0 0 0 3px var(--input-focus);
}

.btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 0.625rem 1.25rem;
    font-size: 0.875rem;
    font-weight: 500;
    text-align: center;
    text-decoration: none;
    border-radius: var(--border-radius);
    transition: var(--transition);
    cursor: pointer;
    border: none;
}

.btn-primary {
    background-color: var(--primary-color);
    color: white;
}

.btn-primary:hover {
    background-color: var(--primary-hover);
}

.time-slots-table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0;
    margin-top: 1.5rem;
    font-size: 0.875rem;
}

.time-slots-table th,
.time-slots-table td {
    padding: 0.75rem 1rem;
    text-align: left;
    border-bottom: 1px solid #e2e8f0;
}

.time-slots-table th {
    background-color: #f8fafc;
    font-weight: 600;
    color: var(--secondary-color);
    text-transform: uppercase;
    font-size: 0.75rem;
    letter-spacing: 0.05em;
}

.time-slots-table tr:hover {
    background-color: #f1f5f9;
}

.slot-actions {
    display: flex;
    gap: 0.5rem;
}

.btn-sm {
    padding: 0.375rem 0.75rem;
    font-size: 0.75rem;
}

.btn-danger {
    background-color: var(--error-text);
    color: white;
}

.btn-danger:hover {
    background-color: #b91c1c;
}

@media (max-width: 768px) {
    .admin-content {
        margin-left: 0;
        padding: 1rem;
    }
    
    .time-slots-table {
        display: block;
        overflow-x: auto;
    }
}
    </style>
</head>
<body>
    <div class="admin-layout">
        <jsp:include page="includes/sidebar.jsp" />
        
        <div class="admin-content">
            <jsp:include page="includes/header.jsp" />
            
            <div class="content-header">
                <h1>Manage Time Slots</h1>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">${errorMessage}</div>
            </c:if>

            <div class="card">
                <h2>Generate Time Slots</h2>
                <form action="${pageContext.request.contextPath}/admin/timeslots" method="post">
                    <div class="form-group">
                        <label for="doctorId">Select Doctor</label>
                        <select name="doctorId" id="doctorId" class="form-control" required onchange="loadDoctorTimeSlots(this.value)">
                            <option value="">Select a doctor</option>
                            <c:forEach var="doctor" items="${doctors}">
                                <option value="${doctor.id}">${doctor.name} - ${doctor.specialization}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="date">Date</label>
                        <input type="date" name="date" id="date" class="form-control" required 
                               min="${LocalDate.now()}" value="${param.date}">
                    </div>

                    <div class="form-group">
                        <label for="startTime">Start Time</label>
                        <input type="time" name="startTime" id="startTime" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label for="endTime">End Time</label>
                        <input type="time" name="endTime" id="endTime" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label for="slotDuration">Slot Duration (minutes)</label>
                        <select name="slotDuration" id="slotDuration" class="form-control" required>
                            <option value="15">15 minutes</option>
                            <option value="30" selected>30 minutes</option>
                            <option value="45">45 minutes</option>
                            <option value="60">60 minutes</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary">Generate Time Slots</button>
                </form>
            </div>

            <div class="card">
                <h2>Doctor Time Slots</h2>
                <div id="timeSlotFilters">
                    <div class="form-group">
                        <label for="filterDoctor">Filter by Doctor</label>
                        <select id="filterDoctor" class="form-control" onchange="filterTimeSlots()">
                            <option value="">All Doctors</option>
                            <c:forEach var="doctor" items="${doctors}">
                                <option value="${doctor.id}">${doctor.name}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="filterDate">Filter by Date</label>
                        <input type="date" id="filterDate" class="form-control" onchange="filterTimeSlots()">
                    </div>

                    <div class="form-group">
                        <label for="filterStatus">Filter by Status</label>
                        <select id="filterStatus" class="form-control" onchange="filterTimeSlots()">
                            <option value="">All Statuses</option>
                            <option value="available">Available</option>
                            <option value="booked">Booked</option>
                        </select>
                    </div>
                </div>

                <div id="loadingIndicator" style="display: none; text-align: center; padding: 20px;">
                    <i class="fas fa-spinner fa-spin"></i> Loading time slots...
                </div>

                <div id="doctorTimeSlots">
                    <table class="time-slots-table">
                        <thead>
                            <tr>
                                <th>Doctor</th>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="timeSlotsTableBody">
                            <c:forEach var="slot" items="${timeSlots}">
                                <tr data-doctor="${slot.doctorTimeSlots[0].doctorId}" data-date="${slot.slotDate}" data-status="${slot.doctorTimeSlots[0].available ? 'available' : 'booked'}">
                                    <td>Dr. ${doctorMap[slot.doctorTimeSlots[0].doctorId].name}</td>
                                    <td>
                                        <fmt:formatDate value="${slot.slotDate}" pattern="MMM dd, yyyy" />
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${slot.startTime}" pattern="hh:mm a" /> - 
                                        <fmt:formatDate value="${slot.endTime}" pattern="hh:mm a" />
                                    </td>
                                    <td>
                                        <span class="status-badge status-${slot.doctorTimeSlots[0].available ? 'available' : 'booked'}">
                                            <c:choose>
                                                <c:when test="${slot.doctorTimeSlots[0].available}">Available</c:when>
                                                <c:otherwise>Booked</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td class="slot-actions">
                                        <form action="${pageContext.request.contextPath}/admin/timeslots" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="slotId" value="${slot.timeslotId}">
                                            <button type="submit" class="btn btn-sm btn-danger" 
                                                    onclick="return confirm('Are you sure you want to delete this time slot?')">
                                                <i class="fas fa-trash"></i> Delete
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty timeSlots}">
                                <tr>
                                    <td colspan="5" class="no-results">No time slots available.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script>
        function filterTimeSlots() {
            const doctorId = document.getElementById('filterDoctor').value;
            const date = document.getElementById('filterDate').value;
            const status = document.getElementById('filterStatus').value;
            const rows = document.querySelectorAll('.time-slots-table tbody tr:not(.no-results)');
            
            let visibleCount = 0;
            
            rows.forEach(row => {
                const showByDoctor = !doctorId || row.dataset.doctor === doctorId;
                const showByDate = !date || row.dataset.date === date;
                const showByStatus = !status || row.dataset.status === status;
                const shouldShow = showByDoctor && showByDate && showByStatus;
                
                row.style.display = shouldShow ? '' : 'none';
                if (shouldShow) visibleCount++;
            });
            
            // Show no results message if nothing visible
            const noResultsRow = document.querySelector('.time-slots-table tbody tr.no-results');
            if (noResultsRow) {
                noResultsRow.style.display = visibleCount === 0 ? '' : 'none';
            }
        }

        function loadDoctorTimeSlots(doctorId) {
            if (!doctorId) return;
            
            // Set the filterDoctor value to match
            document.getElementById('filterDoctor').value = doctorId;
            
            // Show loading indicator
            const loadingIndicator = document.getElementById('loadingIndicator');
            loadingIndicator.style.display = 'block';
            
            try {
                // Try the AJAX approach first
                fetch('${pageContext.request.contextPath}/admin/timeslots?action=getByDoctor&doctorId=' + doctorId)
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Network response was not ok');
                        }
                        return response.json();
                    })
                    .then(data => {
                        console.log('Received time slots data:', data);
                        // Hide loading indicator
                        loadingIndicator.style.display = 'none';
                        
                        // Display the time slots
                        displayTimeSlots(data);
                    })
                    .catch(error => {
                        console.error('Error fetching time slots:', error);
                        // Hide loading indicator
                        loadingIndicator.style.display = 'none';
                        
                        // Fallback to regular filtering if AJAX fails
                        filterTimeSlots();
                    });
            } catch (err) {
                console.error('Exception in fetch:', err);
                // Hide loading indicator
                loadingIndicator.style.display = 'none';
                
                // Fallback to filtering
                filterTimeSlots();
            }
        }
        
        function displayTimeSlots(timeSlots) {
            const tbody = document.getElementById('timeSlotsTableBody');
            
            if (!timeSlots || timeSlots.length === 0) {
                tbody.innerHTML = '<tr class="no-results"><td colspan="5" class="no-results">No time slots available for this doctor.</td></tr>';
                return;
            }
            
            let html = '';
            
            timeSlots.forEach(slot => {
                // Check if doctorTimeSlots array exists and has at least one item
                if (!slot.doctorTimeSlots || slot.doctorTimeSlots.length === 0) {
                    console.error('Time slot missing doctorTimeSlots:', slot);
                    return; // Skip this slot
                }
                
                const doctorTimeSlot = slot.doctorTimeSlots[0];
                const doctorId = doctorTimeSlot.doctorId;
                const status = doctorTimeSlot.available ? 'available' : 'booked';
                
                const formattedDate = new Date(slot.slotDate).toLocaleDateString('en-US', {
                    month: 'short', 
                    day: '2-digit', 
                    year: 'numeric'
                });
                
                // Format times
                const startTime = formatTime(slot.startTime);
                const endTime = formatTime(slot.endTime);
                
                // Get doctor name from window.doctorMap
                const doctorName = window.doctorMap && window.doctorMap[doctorId] ? window.doctorMap[doctorId].name : 'Unknown';
                
                html += `
                    <tr data-doctor="${doctorId}" data-date="${slot.slotDate}" data-status="${status}">
                        <td>Dr. ${doctorName}</td>
                        <td>${formattedDate}</td>
                        <td>${startTime} - ${endTime}</td>
                        <td>
                            <span class="status-badge status-${status}">
                                ${doctorTimeSlot.available ? 'Available' : 'Booked'}
                            </span>
                        </td>
                        <td class="slot-actions">
                            <form action="${pageContext.request.contextPath}/admin/timeslots" method="post" style="display: inline;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="slotId" value="${slot.timeslotId}">
                                <button type="submit" class="btn btn-sm btn-danger" 
                                        onclick="return confirm('Are you sure you want to delete this time slot?')">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                            </form>
                        </td>
                    </tr>
                `;
            });
            
            tbody.innerHTML = html;
        }
        
        function formatTime(timeString) {
            if (!timeString) return '';
            
            // Parse the time string (expecting format like "09:00:00" or ISO string)
            let time;
            try {
                if (timeString.includes('T')) {
                    // Handle ISO date string
                    time = new Date(timeString);
                } else {
                    // Handle time string
                    const [hours, minutes] = timeString.split(':');
                    time = new Date();
                    time.setHours(parseInt(hours, 10));
                    time.setMinutes(parseInt(minutes, 10));
                }
                
                // Format as "hh:mm AM/PM"
                return time.toLocaleTimeString('en-US', {
                    hour: '2-digit',
                    minute: '2-digit',
                    hour12: true
                });
            } catch (err) {
                console.error('Error formatting time:', err, timeString);
                return timeString; // Return original if parsing fails
            }
        }

        // Validate end time is after start time
        document.getElementById('endTime').addEventListener('change', function() {
            const startTime = document.getElementById('startTime').value;
            const endTime = this.value;
            
            if (startTime && endTime && startTime >= endTime) {
                alert('End time must be after start time');
                this.value = '';
            }
        });

        // Set min date for date input to today
        document.getElementById('date').min = new Date().toISOString().split('T')[0];
        
        // Add status badge styles
        document.head.insertAdjacentHTML('beforeend', `
            <style>
                .status-badge {
                    display: inline-block;
                    padding: 0.25rem 0.75rem;
                    border-radius: 9999px;
                    font-size: 0.75rem;
                    font-weight: 500;
                }
                .status-available {
                    background-color: #dcfce7;
                    color: #16a34a;
                }
                .status-booked {
                    background-color: #fee2e2;
                    color: #dc2626;
                }
                .no-results {
                    text-align: center;
                    color: #64748b;
                    padding: 1rem;
                }
            </style>
        `);
        
        // Check if URL has doctorId parameter and load slots if it does
        document.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            const doctorId = urlParams.get('doctorId');
            
            // Create simple access to doctor data
            const doctorSelect = document.getElementById('doctorId');
            window.doctorMap = {};
            
            // Populate from the select options
            Array.from(doctorSelect.options).forEach(option => {
                if (option.value) {
                    // Extract doctor name from the text (format: "Dr. Name - Specialization")
                    let name = option.text.split('-')[0].trim();
                    if (name.startsWith('Dr. ')) {
                        name = name.substring(4);
                    }
                    window.doctorMap[option.value] = {
                        id: option.value,
                        name: name
                    };
                }
            });
            
            if (doctorId) {
                document.getElementById('doctorId').value = doctorId;
                loadDoctorTimeSlots(doctorId);
            } else {
                // Just filter the existing time slots on initial load
                filterTimeSlots();
            }
        });
    </script>
</body>
</html>