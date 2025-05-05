<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - Hospital Management System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #2563eb;
            --primary-dark: #1d4ed8;
            --primary-light: #dbeafe;
            --primary-bg: #f0f9ff;
            --dark: #0f172a;
            --gray-dark: #334155;
            --gray: #64748b;
            --gray-light: #e2e8f0;
            --white: #ffffff;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
        }

      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      body {
            font-family: 'Inter', sans-serif;
        line-height: 1.6;
            color: var(--gray-dark);
            background-color: #f8fafc;
      }

      .container {
            width: 100%;
            max-width: 1280px;
        margin: 0 auto;
            padding: 0 1.5rem;
        }
        /* Page Title */
        .page-title {
            background: linear-gradient(to right, var(--primary-light), #f8fafc);
            padding: 2rem 0;
            margin-bottom: 3rem;
        }

        .page-title h1 {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--dark);
            margin: 0;
        }

        /* About Section */
        .about-section {
            padding: 2rem 0 5rem;
        }

        .about-container {
        display: grid;
        grid-template-columns: 1fr 1fr;
            gap: 3rem;
        align-items: center;
      }

      .about-image {
            border-radius: 1rem;
        overflow: hidden;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            height: 100%;
            max-height: 500px;
      }

      .about-image img {
        width: 100%;
        height: 100%;
        object-fit: cover;
            display: block;
        }

        .about-content {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .about-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--dark);
            position: relative;
            padding-bottom: 1rem;
        }

        .about-title::after {
            content: "";
            position: absolute;
            bottom: 0;
            left: 0;
            width: 80px;
            height: 4px;
            background: var(--primary);
            border-radius: 2px;
      }

      .about-text {
            color: var(--gray);
            font-size: 1.125rem;
            line-height: 1.8;
        }

        .mission-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--dark);
            margin-top: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .mission-title i {
            color: var(--primary);
        }

        /* Features Section */
        .features-section {
            padding: 5rem 0;
            background-color: var(--white);
        }

        .section-header {
            text-align: center;
            margin-bottom: 3rem;
        }

        .section-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--dark);
            margin-bottom: 1rem;
        }

        .section-subtitle {
            font-size: 1.125rem;
            color: var(--gray);
            max-width: 700px;
            margin: 0 auto;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
        }

        .feature-card {
            background: var(--white);
            border-radius: 1rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            padding: 2rem;
            transition: all 0.3s ease;
            border: 1px solid var(--gray-light);
            height: 100%;
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            border-color: var(--primary-light);
        }

        .feature-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 60px;
            height: 60px;
            background: var(--primary-light);
            color: var(--primary);
            border-radius: 12px;
            margin-bottom: 1.5rem;
            font-size: 1.5rem;
        }

        .feature-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 1rem;
        }

        .feature-text {
            color: var(--gray);
            font-size: 1rem;
            line-height: 1.6;
        }

        /* Why Choose Us Section */
        .why-us-section {
            padding: 5rem 0;
            background-color: var(--primary-bg);
        }

        .why-us-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
      }

        .why-us-card {
            background: var(--white);
            border-radius: 1rem;
            padding: 2rem;
        text-align: center;
            transition: all 0.3s ease;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }

        .why-us-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }

        .why-us-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 70px;
            height: 70px;
            background: var(--primary-light);
            color: var(--primary);
            border-radius: 50%;
            margin-bottom: 1.5rem;
            font-size: 1.75rem;
        }

        .why-us-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 1rem;
        }

        .why-us-text {
            color: var(--gray);
            font-size: 1rem;
        }

        /* Doctors Section */
        .doctors-section {
            padding: 5rem 0;
            background-color: var(--white);
        }

        .doctors-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 2.5rem;
        }

        .doctor-card {
            background: var(--white);
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            transition: all 0.3s ease;
            border: 1px solid var(--gray-light);
        }

        .doctor-card:hover {
        transform: translateY(-5px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            border-color: var(--primary-light);
        }

        .doctor-image {
            width: 100%;
            height: 280px;
            overflow: hidden;
            position: relative;
        }

        .doctor-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .doctor-card:hover .doctor-image img {
            transform: scale(1.05);
        }

        .doctor-info {
            padding: 1.5rem;
        }

        .doctor-name {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 0.5rem;
        }

        .doctor-specialty {
            color: var(--primary);
            font-weight: 500;
            margin-bottom: 1rem;
            font-size: 1rem;
        }

        .doctor-details {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .doctor-detail {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--gray);
            font-size: 0.875rem;
        }

        .doctor-detail i {
            color: var(--primary);
            font-size: 1rem;
        }

        /* Footer */
        .footer {
            background-color: var(--dark);
            color: var(--white);
            padding: 4rem 0 2rem;
        }

        .footer-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 3rem;
        }

        .footer-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            color: var(--white);
        }

        .footer-links {
            list-style: none;
        }

        .footer-link {
            margin-bottom: 0.75rem;
        }

        .footer-link a {
            color: var(--gray-light);
            text-decoration: none;
            transition: color 0.2s ease;
        }

        .footer-link a:hover {
            color: var(--primary-light);
        }

        .footer-bottom {
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            margin-top: 3rem;
            padding-top: 2rem;
            text-align: center;
            color: var(--gray-light);
            font-size: 0.875rem;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .about-container {
                gap: 2rem;
            }
            
            .about-title {
                font-size: 1.75rem;
            }
            
            .about-text {
                font-size: 1rem;
            }
      }

      @media (max-width: 768px) {
            .header-container {
                flex-direction: column;
                gap: 1rem;
                padding: 1rem;
            }
            
            .nav, .auth-buttons {
                flex-wrap: wrap;
                justify-content: center;
                gap: 1rem;
            }
            
            .page-title h1 {
                font-size: 2rem;
                text-align: center;
            }
            
            .about-container {
          grid-template-columns: 1fr;
        }

        .about-image {
                max-height: 350px;
                order: -1;
            }
            
            .section-title {
                font-size: 1.75rem;
            }
            
            .features-grid, .why-us-grid, .doctors-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 480px) {
            .page-title h1 {
                font-size: 1.75rem;
            }
            
            .about-title {
                font-size: 1.5rem;
            }
            
            .section-title {
                font-size: 1.5rem;
            }
            
            .feature-card, .why-us-card {
                padding: 1.5rem;
        }
      }
    </style>
  </head>
  <body>
    <jsp:include page="includes/header.jsp" />

    <!-- Page Title -->
    <section class="page-title">
    <div class="container">
        <h1>About Us</h1>
        </div>
    </section>

    <!-- About Section -->
    <section class="about-section">
        <div class="container">
            <div class="about-container">
                <div class="about-image">
                    <img src="https://images.unsplash.com/photo-1587351021759-3e566b6af7cc?q=80&w=2072&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" alt="Hospital Building">
                </div>
        <div class="about-content">
                    <h2 class="about-title">Our Hospital</h2>
                    <p class="about-text">
                        At BookGarauSallah, we are dedicated to revolutionizing healthcare access through our innovative appointment booking platform. Combining cutting-edge technology with compassionate care, we bridge the gap between patients and healthcare providers in Nepal and beyond.
                    </p>
                    <p class="about-text">
                        Our name "BookGarauSallah" (बुक गरौं सल्लाह) embodies our core purpose - to make medical consultations easily accessible to all. We've assembled a network of the country's finest healthcare professionals across various specialties to ensure our patients receive world-class medical care with the convenience of modern technology.
                    </p>
                    <h3 class="mission-title"><i class="fas fa-star"></i> Our Mission</h3>
                    <p class="about-text">
                        To transform healthcare accessibility in Nepal by connecting patients with the right medical professionals through a seamless digital platform. We strive to eliminate barriers to quality healthcare by providing a user-friendly system where patients can easily book appointments, consult with specialists, and manage their medical journey - all in one place. Our commitment is to improve health outcomes while respecting the time and needs of both patients and healthcare providers.
                    </p>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features-section">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">What We Offer</h2>
                <p class="section-subtitle">Our comprehensive platform provides innovative solutions for patients, doctors, and administrators.</p>
            </div>

            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <h3 class="feature-title">Effortless Appointment Booking</h3>
                    <p class="feature-text">Patients can easily schedule appointments anytime, anywhere with our intuitive booking system.</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <h3 class="feature-title">Smart Doctor Scheduling</h3>
                    <p class="feature-text">Doctors can manage their availability and appointments in real-time, optimizing their workflow.</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <h3 class="feature-title">Centralized Admin Dashboard</h3>
                    <p class="feature-text">Admins get a complete overview of doctor schedules, patient activity, and hospital operations.</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-file-medical"></i>
                    </div>
                    <h3 class="feature-title">Secure Patient Records</h3>
                    <p class="feature-text">Quick and safe access to medical history, reports, and more with advanced security protocols.</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-lock"></i>
                    </div>
                    <h3 class="feature-title">User Roles & Permissions</h3>
                    <p class="feature-text">Personalized access for patients, doctors, and admins for maximum security and usability.</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-comments"></i>
                    </div>
                    <h3 class="feature-title">Integrated Communication</h3>
                    <p class="feature-text">Seamless communication between patients and healthcare providers through secure messaging.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Why Choose Us Section -->
    <section class="why-us-section">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Why Choose Us?</h2>
                <p class="section-subtitle">We're dedicated to providing the best healthcare management experience possible.</p>
            </div>

            <div class="why-us-grid">
                <div class="why-us-card">
                    <div class="why-us-icon">
                        <i class="fas fa-hand-pointer"></i>
                    </div>
                    <h3 class="why-us-title">Easy to Use</h3>
                    <p class="why-us-text">Intuitive interface designed for users of all technical abilities.</p>
                </div>

                <div class="why-us-card">
                    <div class="why-us-icon">
                        <i class="fas fa-headset"></i>
                    </div>
                    <h3 class="why-us-title">24/7 Support</h3>
                    <p class="why-us-text">Our dedicated team is always available to assist you with any issues.</p>
                </div>

                <div class="why-us-card">
                    <div class="why-us-icon">
                        <i class="fas fa-expand-arrows-alt"></i>
                    </div>
                    <h3 class="why-us-title">Scalable Solution</h3>
                    <p class="why-us-text">Perfect for small clinics or large hospitals with customizable features.</p>
          </div>

                <div class="why-us-card">
                    <div class="why-us-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h3 class="why-us-title">Security First</h3>
                    <p class="why-us-text">Built with security and privacy at its core to protect sensitive data.</p>
                </div>
          </div>
        </div>
    </section>

    <!-- Doctors Section -->
    <section class="doctors-section">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Our Head Doctors</h2>
                <p class="section-subtitle">Meet our team of experienced healthcare professionals dedicated to providing exceptional care.</p>
            </div>

            <div class="doctors-grid">
                <c:forEach var="doctor" items="${headDoctors}">
                    <div class="doctor-card">
                        <div class="doctor-image">
                            <img src="${doctor.imageUrl}" alt="Dr. ${doctor.name}">
                        </div>
                        <div class="doctor-info">
                            <h3 class="doctor-name">${doctor.name}</h3>
                            <div class="doctor-specialty">${doctor.specialization}</div>
                            <div class="doctor-details">
                                <div class="doctor-detail">
                                    <i class="fas fa-graduation-cap"></i>
                                    <span>${doctor.qualification}</span>
                                </div>
                                <div class="doctor-detail">
                                    <i class="fas fa-clock"></i>
                                    <span>${doctor.experience} Years Experience</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <!-- Fallback content if no doctors are available -->
                <c:if test="${empty headDoctors}">
                    <div class="doctor-card">
                        <div class="doctor-image">
                            <img src="https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80" alt="Dr. John Smith">
                        </div>
                        <div class="doctor-info">
                            <h3 class="doctor-name">Dr. John Smith</h3>
                            <div class="doctor-specialty">Cardiology</div>
                            <div class="doctor-details">
                                <div class="doctor-detail">
                                    <i class="fas fa-graduation-cap"></i>
                                    <span>MD, FACC</span>
                                </div>
                                <div class="doctor-detail">
                                    <i class="fas fa-clock"></i>
                                    <span>15 Years Experience</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="doctor-card">
                        <div class="doctor-image">
                            <img src="https://images.unsplash.com/photo-1594824476967-48c8b964273f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2074&q=80" alt="Dr. Sarah Johnson">
                        </div>
                        <div class="doctor-info">
                            <h3 class="doctor-name">Dr. Sarah Johnson</h3>
                            <div class="doctor-specialty">Neurology</div>
                            <div class="doctor-details">
                                <div class="doctor-detail">
                                    <i class="fas fa-graduation-cap"></i>
                                    <span>MD, PhD</span>
                                </div>
                                <div class="doctor-detail">
                                    <i class="fas fa-clock"></i>
                                    <span>12 Years Experience</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="doctor-card">
                        <div class="doctor-image">
                            <img src="https://images.unsplash.com/photo-1622253692010-333f2da6031d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2064&q=80" alt="Dr. Michael Chen">
                        </div>
                        <div class="doctor-info">
                            <h3 class="doctor-name">Dr. Michael Chen</h3>
                            <div class="doctor-specialty">Oncology</div>
                            <div class="doctor-details">
                                <div class="doctor-detail">
                                    <i class="fas fa-graduation-cap"></i>
                                    <span>MD, FASCO</span>
                                </div>
                                <div class="doctor-detail">
                                    <i class="fas fa-clock"></i>
                                    <span>18 Years Experience</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
      </div>
    </div>
    </section>

    <jsp:include page="includes/footer.jsp" />
  </body>
</html>