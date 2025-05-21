<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Email Verification - Doctor Appointment System</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #3b82f6;
            --primary-light: #eff6ff;
            --primary-dark: #1d4ed8;
            --success: #10b981;
            --error: #ef4444;
            --warning: #f59e0b;
            --dark: #1e293b;
            --text: #334155;
            --text-light: #64748b;
            --border: #e2e8f0;
            --bg: #f8fafc;
            --white: #ffffff;
            --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --radius: 12px;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            line-height: 1.6;
            color: var(--text);
            background-color: var(--primary-light);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
        }
        
        .top-shape {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 300px;
            background-color: var(--primary-light);
            clip-path: polygon(0 0, 100% 0, 100% 75%, 50% 100%, 0 75%);
            z-index: -1;
        }
        
        .verify-container {
            margin: auto;
            width: 100%;
            max-width: 500px;
            padding: 20px;
            z-index: 1;
        }
        
        .card {
            background-color: var(--white);
            padding: 35px;
            border-radius: var(--radius);
            box-shadow: var(--shadow-lg);
            text-align: center;
        }
        
        .illustration {
            width: 150px;
            height: 150px;
            margin: 0 auto 20px;
            background-color: var(--primary-light);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }
        
        .illustration img {
            width: 100%;
            height: auto;
        }
        
        .verify-title {
            font-size: 24px;
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 15px;
        }
        
        .verify-subtitle {
            font-size: 14px;
            color: var(--text-light);
            margin-bottom: 30px;
        }
        
        .otp-container {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-bottom: 30px;
        }
        
        .otp-box {
            width: 50px;
            height: 60px;
            border: 1px solid var(--border);
            border-radius: 8px;
            font-size: 24px;
            font-weight: 600;
            text-align: center;
            color: var(--dark);
            background-color: var(--bg);
            transition: all 0.3s ease;
        }
        
        .otp-box:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.2);
            outline: none;
        }
        
        .verify-btn {
            background-color: var(--primary);
            color: var(--white);
            border: none;
            border-radius: 30px;
            padding: 12px 30px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
            max-width: 250px;
            margin: 0 auto 15px;
            display: block;
        }
        
        .verify-btn:hover {
            background-color: var(--primary-dark);
            transform: translateY(-2px);
        }
        
        .cancel-btn {
            background: none;
            border: none;
            color: var(--text-light);
            font-size: 14px;
            cursor: pointer;
            transition: color 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        
        .cancel-btn:hover {
            color: var(--primary);
        }
        
        .alert {
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            display: flex;
            align-items: center;
            text-align: left;
        }
        
        .alert i {
            margin-right: 10px;
            font-size: 16px;
        }
        
        .alert-success {
            background-color: rgba(16, 185, 129, 0.1);
            color: var(--success);
            border: 1px solid rgba(16, 185, 129, 0.2);
        }
        
        .alert-error {
            background-color: rgba(239, 68, 68, 0.1);
            color: var(--error);
            border: 1px solid rgba(239, 68, 68, 0.2);
        }
        
        .alert-warning {
            background-color: rgba(245, 158, 11, 0.1);
            color: var(--warning);
            border: 1px solid rgba(245, 158, 11, 0.2);
        }
        
        .timer {
            font-size: 14px;
            color: var(--text-light);
            margin-top: 20px;
        }
        
        .timer strong {
            color: var(--primary);
            font-weight: 600;
        }
        
        .resend-link {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
            cursor: pointer;
            transition: color 0.3s ease;
        }
        
        .resend-link:hover {
            text-decoration: underline;
        }
        
        .resend-link:disabled {
            color: var(--text-light);
            cursor: not-allowed;
            text-decoration: none;
        }
        
        @media (max-width: 480px) {
            .verify-container {
                padding: 15px;
            }
            
            .card {
                padding: 25px 20px;
            }
            
            .otp-box {
                width: 45px;
                height: 55px;
                font-size: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="top-shape"></div>
    
    <div class="verify-container">
        <div class="card">
            <div class="illustration">
                <img src="https://img.freepik.com/free-vector/otp-verification-concept-illustration_114360-7967.jpg?w=826&t=st=1707134150~exp=1707134750~hmac=a5e8fcb5a53cd6b9d73ce6b43e4a07c4d30a2e2855e6e1c3c2c6cdeaa2eb3b31" alt="Verification">
            </div>
            
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${errorMessage}</span>
                </div>
            </c:if>
            
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <span>${successMessage}</span>
                </div>
            </c:if>
            
            <c:if test="${not empty warningMessage}">
                <div class="alert alert-warning">
                    <i class="fas fa-exclamation-triangle"></i>
                    <span>${warningMessage}</span>
                </div>
            </c:if>
            
            <h1 class="verify-title">Please Verify Account</h1>
            <p class="verify-subtitle">Enter the six digit code we sent to your email address to verify your new hospital account.</p>
            
            <form id="verifyForm" action="${pageContext.request.contextPath}/verify-otp" method="post">
                <input type="hidden" name="email" value="${email}">
                <input type="hidden" id="otp" name="otp">
                
                <div class="otp-container">
                    <input type="text" class="otp-box" maxlength="1" data-index="1">
                    <input type="text" class="otp-box" maxlength="1" data-index="2">
                    <input type="text" class="otp-box" maxlength="1" data-index="3">
                    <input type="text" class="otp-box" maxlength="1" data-index="4">
                    <input type="text" class="otp-box" maxlength="1" data-index="5">
                    <input type="text" class="otp-box" maxlength="1" data-index="6">
                </div>
                
                <button type="submit" class="verify-btn">Verify & Continue</button>
                <a href="${pageContext.request.contextPath}/login" class="cancel-btn">Cancel</a>
                
                <div class="timer">
                    Code expires in <strong id="timer">15:00</strong> minutes.
                    <div id="resend-container">
                        <button type="button" class="resend-link" id="resendBtn" disabled onclick="document.getElementById('resendForm').submit();">
                            Didn't receive the code? <span id="resendTimer">Resend (1:00)</span>
                        </button>
                    </div>
                </div>
            </form>
            
            <form id="resendForm" action="${pageContext.request.contextPath}/verify-otp" method="post" style="display: none;">
                <input type="hidden" name="email" value="${email}">
                <input type="hidden" name="action" value="resend">
            </form>
        </div>
    </div>
    
    <script>
        // Handle OTP input focus and navigation
        const otpBoxes = document.querySelectorAll('.otp-box');
        const hiddenOtpInput = document.getElementById('otp');
        
        // Focus the first box on page load
        document.addEventListener('DOMContentLoaded', function() {
            otpBoxes[0].focus();
        });
        
        // Event listeners for each OTP box
        otpBoxes.forEach((box, index) => {
            // Handle input
            box.addEventListener('input', function(e) {
                const value = this.value;
                
                // Ensure only numbers are entered
                if (!/^\d*$/.test(value)) {
                    this.value = '';
                    return;
                }
                
                // Move to next input box if value is entered
                if (value !== '' && index < otpBoxes.length - 1) {
                    otpBoxes[index + 1].focus();
                }
                
                // Update the hidden OTP input
                updateHiddenOtp();
                
                // Auto-submit if all boxes are filled
                if (isOtpComplete()) {
                    setTimeout(() => {
                        document.getElementById('verifyForm').submit();
                    }, 300);
                }
            });
            
            // Handle paste
            box.addEventListener('paste', function(e) {
                e.preventDefault();
                
                const pastedData = (e.clipboardData || window.clipboardData).getData('text');
                const digits = pastedData.replace(/\D/g, '').split('').slice(0, 6);
                
                digits.forEach((digit, i) => {
                    if (i < otpBoxes.length) {
                        otpBoxes[i].value = digit;
                    }
                });
                
                // Move focus to the appropriate box
                if (digits.length < otpBoxes.length) {
                    otpBoxes[digits.length].focus();
                } else {
                    otpBoxes[otpBoxes.length - 1].focus();
                }
                
                // Update hidden OTP and potentially submit
                updateHiddenOtp();
                
                if (isOtpComplete()) {
                    setTimeout(() => {
                        document.getElementById('verifyForm').submit();
                    }, 300);
                }
            });
            
            // Handle key events for navigation
            box.addEventListener('keydown', function(e) {
                // Move to previous box on backspace if current box is empty
                if (e.key === 'Backspace' && this.value === '' && index > 0) {
                    otpBoxes[index - 1].focus();
                }
                
                // Move to next box on right arrow
                if (e.key === 'ArrowRight' && index < otpBoxes.length - 1) {
                    otpBoxes[index + 1].focus();
                }
                
                // Move to previous box on left arrow
                if (e.key === 'ArrowLeft' && index > 0) {
                    otpBoxes[index - 1].focus();
                }
            });
        });
        
        // Update the hidden OTP input with values from all boxes
        function updateHiddenOtp() {
            let otp = '';
            otpBoxes.forEach(box => {
                otp += box.value;
            });
            hiddenOtpInput.value = otp;
        }
        
        // Check if all OTP boxes are filled
        function isOtpComplete() {
            return [...otpBoxes].every(box => box.value.length === 1);
        }
        
        // Timer functionality
        let otpTimerMinutes = 15;
        let otpTimerSeconds = 0;
        let resendTimerSeconds = 60;
        
        function updateOTPTimer() {
            if (otpTimerSeconds === 0) {
                if (otpTimerMinutes === 0) {
                    // OTP expired
                    document.getElementById('timer').innerHTML = 'Expired';
                    document.getElementById('timer').style.color = 'var(--error)';
                    clearInterval(otpTimerInterval);
                    return;
                }
                
                otpTimerMinutes--;
                otpTimerSeconds = 59;
            } else {
                otpTimerSeconds--;
            }
            
            document.getElementById('timer').innerHTML = 
                (otpTimerMinutes < 10 ? '0' + otpTimerMinutes : otpTimerMinutes) + ':' + 
                (otpTimerSeconds < 10 ? '0' + otpTimerSeconds : otpTimerSeconds);
        }
        
        function updateResendTimer() {
            if (resendTimerSeconds <= 0) {
                // Enable resend button
                document.getElementById('resendBtn').disabled = false;
                document.getElementById('resendTimer').innerHTML = 'Resend Now';
                clearInterval(resendTimerInterval);
                return;
            }
            
            resendTimerSeconds--;
            document.getElementById('resendTimer').innerHTML = 
                'Resend (' + Math.floor(resendTimerSeconds / 60) + ':' + 
                (resendTimerSeconds % 60 < 10 ? '0' + resendTimerSeconds % 60 : resendTimerSeconds % 60) + ')';
        }
        
        // Start timers
        const otpTimerInterval = setInterval(updateOTPTimer, 1000);
        const resendTimerInterval = setInterval(updateResendTimer, 1000);
    </script>
</body>
</html> 