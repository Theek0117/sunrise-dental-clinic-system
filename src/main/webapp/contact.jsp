<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact & Appointment Booking | Sunrise Dental Clinic</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        :root {
            --brand-navy: #0c3d4f;
            --brand-teal: #0ea5b4;
            --brand-cyan: #d6f4f8;
            --brand-dark: #072b38;
            --font-family: 'Poppins', sans-serif;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; font-family: var(--font-family); }
        body { background: #f4f8fa; color: #334155; min-height: 100vh; display: flex; flex-direction: column; }

        header {
            background: linear-gradient(135deg, #093747, #0c4d61);
            padding: 20px 40px;
            color: #ffffff;
            box-shadow: 0 8px 25px rgba(9, 55, 71, 0.18);
        }

        .header-inner {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .brand-link {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            color: #ffffff;
        }

        .brand-link img { width: 44px; height: 44px; object-fit: contain; }
        .brand-text strong { font-size: 20px; font-weight: 800; display: block; line-height: 1; }
        .brand-text span { font-size: 11px; letter-spacing: 2px; color: var(--brand-cyan); text-transform: uppercase; }

        .nav-links { display: flex; align-items: center; gap: 16px; }
        .nav-link-btn {
            color: #ffffff;
            text-decoration: none;
            font-size: 13.5px;
            font-weight: 600;
            padding: 8px 16px;
            border-radius: 10px;
            transition: 0.2s;
        }
        .nav-link-btn:hover { background: rgba(255, 255, 255, 0.15); }
        .nav-link-btn.primary {
            background: var(--brand-teal);
            box-shadow: 0 6px 18px rgba(14, 165, 180, 0.35);
        }
        .nav-link-btn.primary:hover { background: #12b7c7; }

        .main-container {
            max-width: 1100px;
            margin: 40px auto;
            padding: 0 20px;
            flex: 1;
            width: 100%;
        }

        .hero-banner {
            background: linear-gradient(135deg, #062b38 0%, #0c4d61 100%);
            border-radius: 24px;
            padding: 40px 45px;
            color: #ffffff;
            margin-bottom: 35px;
            box-shadow: 0 20px 45px rgba(6, 43, 56, 0.2);
            border: 1.5px solid rgba(14, 165, 180, 0.35);
            display: flex;
            align-items: center;
            gap: 30px;
        }

        .hero-icon {
            width: 80px;
            height: 80px;
            border-radius: 22px;
            background: linear-gradient(135deg, #0ea5b4, #087f8c);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 38px;
            color: #ffffff;
            flex-shrink: 0;
            box-shadow: 0 10px 25px rgba(14, 165, 180, 0.35);
        }

        .hero-text { flex: 1; }
        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(254, 240, 138, 0.18);
            border: 1px solid rgba(254, 240, 138, 0.4);
            color: #fef08a;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            padding: 4px 14px;
            border-radius: 20px;
            margin-bottom: 12px;
        }

        .hero-text h1 { font-size: 28px; font-weight: 800; margin-bottom: 10px; color: #ffffff; }
        .hero-text p { font-size: 14.5px; color: #cde6ef; line-height: 1.7; margin-bottom: 22px; }

        .action-btns-wrap { display: flex; gap: 14px; flex-wrap: wrap; }
        .action-cta {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 13px 24px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.2s ease;
        }
        .action-cta.phone { background: #0ea5b4; color: #ffffff; box-shadow: 0 8px 20px rgba(14, 165, 180, 0.35); }
        .action-cta.phone:hover { background: #11b8c9; transform: translateY(-2px); }
        .action-cta.whatsapp { background: #25d366; color: #ffffff; box-shadow: 0 8px 20px rgba(37, 211, 102, 0.3); }
        .action-cta.whatsapp:hover { background: #22bf5b; transform: translateY(-2px); }

        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 22px;
            margin-bottom: 35px;
        }

        .info-card {
            background: #ffffff;
            border-radius: 18px;
            padding: 28px 24px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.04);
            transition: all 0.25s ease;
        }
        .info-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 14px 30px rgba(14, 165, 180, 0.12);
            border-color: #a4cddc;
        }

        .card-icon {
            width: 48px;
            height: 48px;
            border-radius: 14px;
            background: #e0f7fa;
            color: var(--brand-teal);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            margin-bottom: 16px;
        }

        .info-card h3 { font-size: 17px; font-weight: 700; color: var(--brand-navy); margin-bottom: 8px; }
        .info-card strong { font-size: 15px; color: #0ea5b4; display: block; margin-bottom: 6px; }
        .info-card p { font-size: 13px; color: #64748b; line-height: 1.6; }

        .steps-card {
            background: #ffffff;
            border-radius: 20px;
            padding: 32px 30px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 8px 25px rgba(0,0,0,0.04);
        }

        .steps-card h2 { font-size: 20px; font-weight: 700; color: var(--brand-navy); margin-bottom: 20px; }
        .steps-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
        .step-item { display: flex; gap: 14px; }
        .step-badge {
            width: 38px;
            height: 38px;
            border-radius: 10px;
            background: #e0f7fa;
            color: var(--brand-teal);
            font-weight: 800;
            font-size: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        .step-text h4 { font-size: 15px; font-weight: 700; color: var(--brand-navy); margin-bottom: 4px; }
        .step-text p { font-size: 12.5px; color: #64748b; line-height: 1.6; }

        footer {
            background: #072b38;
            color: #94a3b8;
            padding: 25px 20px;
            text-align: center;
            font-size: 13px;
            margin-top: auto;
        }

        @media (max-width: 800px) {
            .hero-banner { flex-direction: column; text-align: center; padding: 30px 20px; }
            .action-btns-wrap { justify-content: center; }
            .steps-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

    <header>
        <div class="header-inner">
            <a href="<%= contextPath %>/" class="brand-link">
                <img src="<%= contextPath %>/images/logo1.png" alt="Sunrise Dental Clinic">
                <div class="brand-text">
                    <strong>Sunrise</strong>
                    <span>Dental Clinic</span>
                </div>
            </a>

            <div class="nav-links">
                <a href="<%= contextPath %>/" class="nav-link-btn"><i class="bi bi-arrow-left"></i> Back to Home</a>
                <a href="<%= contextPath %>/login.jsp" class="nav-link-btn primary"><i class="bi bi-person-lock"></i> Staff Portal</a>
            </div>
        </div>
    </header>

    <main class="main-container">
        <div class="hero-banner">
            <div class="hero-icon">
                <i class="bi bi-telephone-inbound-fill"></i>
            </div>
            <div class="hero-text">
                <span class="hero-badge"><i class="bi bi-info-circle-fill"></i> PHONE & DIRECT APPOINTMENT BOOKINGS ONLY</span>
                <h1>Call Us to Book Your Appointment</h1>
                <p>
                    To ensure the most suitable specialist is assigned to your dental concern and to confirm immediate real-time availability, <strong>all patient appointments are arranged by phone or WhatsApp directly with our reception desk</strong>.
                </p>
                <div class="action-btns-wrap">
                    <a href="tel:+18005550199" class="action-cta phone"><i class="bi bi-telephone-fill"></i> Call Reception: +1 (800) 555-0199</a>
                    <a href="https://wa.me/18005550199" target="_blank" class="action-cta whatsapp"><i class="bi bi-whatsapp"></i> Chat on WhatsApp</a>
                </div>
            </div>
        </div>

        <div class="cards-grid">
            <div class="info-card">
                <div class="card-icon"><i class="bi bi-telephone-fill"></i></div>
                <h3>Reception Hotlines</h3>
                <strong>+1 (800) 555-0199</strong>
                <p>Mon - Sat: 9:00 AM - 7:00 PM<br>24/7 Dental Emergency: +1 (800) 555-0911</p>
            </div>

            <div class="info-card">
                <div class="card-icon"><i class="bi bi-envelope-at-fill"></i></div>
                <h3>Email Inquiries</h3>
                <strong>appointments@sunrisedental.com</strong>
                <p>Quick replies within 24 hours.<br>General: hello@sunrisedental.com</p>
            </div>

            <div class="info-card">
                <div class="card-icon"><i class="bi bi-geo-alt-fill"></i></div>
                <h3>Clinic Location</h3>
                <strong>24 Harbor Avenue, Suite 4</strong>
                <p>Colombo 03, Dental Pavilion<br>Free reserved parking & wheelchair accessible</p>
            </div>

            <div class="info-card">
                <div class="card-icon"><i class="bi bi-clock-fill"></i></div>
                <h3>Working Hours</h3>
                <strong>Mon - Sat: 9 AM - 7 PM</strong>
                <p>Sunday: 10:00 AM - 4:00 PM<br>Emergency care available 24/7 on call</p>
            </div>
        </div>

        <div class="steps-card">
            <h2>How to Book Your Dental Consultation</h2>
            <div class="steps-grid">
                <div class="step-item">
                    <div class="step-badge">1</div>
                    <div class="step-text">
                        <h4>Call Our Hotline</h4>
                        <p>Call our reception at +1 (800) 555-0199 or message via WhatsApp.</p>
                    </div>
                </div>
                <div class="step-item">
                    <div class="step-badge">2</div>
                    <div class="step-text">
                        <h4>Choose Doctor & Slot</h4>
                        <p>Our receptionist checks live schedules to find your preferred time and specialist.</p>
                    </div>
                </div>
                <div class="step-item">
                    <div class="step-badge">3</div>
                    <div class="step-text">
                        <h4>Instant Confirmation</h4>
                        <p>Get immediate SMS and email reminders with your appointment details.</p>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <footer>
        <p>&copy; 2026 Sunrise Dental Clinic. All rights reserved.</p>
    </footer>

</body>
</html>
