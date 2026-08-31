<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

  <!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Dental Clinic</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;500;600;700&family=Poppins:wght@300;400;500;600;700;800&display=swap"
      rel="stylesheet"
    />
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
    <link rel="icon" type="image/png" href="images/logo1.png">
  </head>
  <body>

    <div id="intro-loader">

        <svg
            id="intro-logo"
            width="225"
            height="42"
            viewBox="0 0 225 42"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
        >

            <path
                id="logo-path"
                d="M25.8545 32.375C26.4795 32.0208 26.7712 31.3542 26.7295 30.375C26.667 29.2708 25.6982 28.2708 23.8232 27.375C21.9691 26.4583 19.7191 25.5833 17.0732 24.75C15.9691 24.3958 15.1253 24.1146 14.542 23.9062C11.8962 23.0104 9.63574 22.0729 7.76074 21.0938C5.90658 20.1146 4.34408 18.8333 3.07324 17.25C1.80241 15.6667 1.11491 13.7188 1.01074 11.4062C0.927409 9.15625 1.34408 7.25 2.26074 5.6875C3.17741 4.125 4.43783 2.95833 6.04199 2.1875C7.64616 1.39583 9.43783 1 11.417 1H34.1045V8.96875H12.417C11.7295 8.96875 11.0628 9.15625 10.417 9.53125C9.77116 9.88542 9.51074 10.5521 9.63574 11.5312C9.71908 12.2812 10.1878 12.9792 11.042 13.625C11.917 14.25 12.9899 14.8229 14.2607 15.3438C15.5316 15.8438 17.3024 16.4896 19.5732 17.2812C19.8857 17.3854 20.1253 17.4583 20.292 17.5C23.292 18.5417 25.8128 19.5729 27.8545 20.5938C29.917 21.5938 31.667 22.9167 33.1045 24.5625C34.542 26.1875 35.2816 28.1667 35.3232 30.5C35.3857 33.9375 34.4378 36.5312 32.4795 38.2812C30.5212 40.0104 28.0003 40.875 24.917 40.875H2.22949V32.9062H23.9482C24.5941 32.9062 25.2295 32.7292 25.8545 32.375ZM46.3857 17.3125C46.3857 21.2083 47.1878 24.3125 48.792 26.625C50.3962 28.9375 52.3753 30.5625 54.7295 31.5C57.0837 32.4375 59.5003 32.9062 61.9795 32.9062V1H70.5732V40.875H62.2607C57.1357 40.875 52.7295 39.8542 49.042 37.8125C45.3545 35.7708 42.5524 33.0208 40.6357 29.5625C38.7399 26.0833 37.792 22.25 37.792 18.0625V1H46.3857V17.3125ZM86.5107 3.34375C89.8857 4.88542 92.7503 7.21875 95.1045 10.3438V1H103.729V26.9062C103.729 26.9479 103.729 26.9896 103.729 27.0312V40.875H95.1045V28.125C95.1045 26.4792 94.6566 24.6458 93.7607 22.625C92.8649 20.6042 91.6982 18.6875 90.2607 16.875C88.8441 15.0417 87.3649 13.5625 85.8232 12.4375C84.2816 11.2917 82.9066 10.7188 81.6982 10.7188V40.875H73.1045V1H73.917C78.9587 1 83.1566 1.78125 86.5107 3.34375ZM131.011 40.875L119.386 27.9375C117.927 29.1667 116.802 30.6146 116.011 32.2812C115.219 33.9479 114.823 35.9375 114.823 38.25V40.875H106.229V38.25C106.229 34.1875 107.167 30.6562 109.042 27.6562C110.938 24.6562 113.813 21.9479 117.667 19.5312C118.875 18.7604 120.084 18.0938 121.292 17.5312C122.5 16.9479 123.938 16.3021 125.604 15.5938C127.771 14.6771 129.334 13.9271 130.292 13.3438C131.271 12.7396 131.813 12.0209 131.917 11.1875C132.063 10.25 131.834 9.64583 131.229 9.375C130.646 9.10417 129.969 8.96875 129.198 8.96875C129.177 8.96875 129.157 8.96875 129.136 8.96875H106.229V1H130.136C132.032 1 133.792 1.46875 135.417 2.40625C137.063 3.34375 138.344 4.61458 139.261 6.21875C140.198 7.82292 140.625 9.55208 140.542 11.4062C140.417 13.5312 139.802 15.3021 138.698 16.7188C137.615 18.1354 136.302 19.2812 134.761 20.1562C133.219 21.0104 131.136 21.9792 128.511 23.0625C127.865 23.3333 127.386 23.5312 127.073 23.6562L142.573 40.875H131.011ZM145.104 40.875V1H153.698V40.875H145.104ZM181.104 32.375C181.729 32.0208 182.021 31.3542 181.979 30.375C181.917 29.2708 180.948 28.2708 179.073 27.375C177.219 26.4583 174.969 25.5833 172.323 24.75C171.219 24.3958 170.375 24.1146 169.792 23.9062C167.146 23.0104 164.886 22.0729 163.011 21.0938C161.157 20.1146 159.594 18.8333 158.323 17.25C157.052 15.6667 156.365 13.7188 156.261 11.4062C156.177 9.15625 156.594 7.25 157.511 5.6875C158.427 4.125 159.688 2.95833 161.292 2.1875C162.896 1.39583 164.688 1 166.667 1H189.354V8.96875H167.667C166.979 8.96875 166.313 9.15625 165.667 9.53125C165.021 9.88542 164.761 10.5521 164.886 11.5312C164.969 12.2812 165.438 12.9792 166.292 13.625C167.167 14.25 168.24 14.8229 169.511 15.3438C170.782 15.8438 172.552 16.4896 174.823 17.2812C175.136 17.3854 175.375 17.4583 175.542 17.5C178.542 18.5417 181.063 19.5729 183.104 20.5938C185.167 21.5938 186.917 22.9167 188.354 24.5625C189.792 26.1875 190.532 28.1667 190.573 30.5C190.636 33.9375 189.688 36.5312 187.729 38.2812C185.771 40.0104 183.25 40.875 180.167 40.875H157.479V32.9062H179.198C179.844 32.9062 180.479 32.7292 181.104 32.375ZM223.386 24.9375H201.636V32.9062H223.386V40.875H193.042V23.8438C193.042 19.6562 193.99 15.8333 195.886 12.375C197.802 8.89583 200.604 6.13542 204.292 4.09375C207.979 2.03125 212.386 1 217.511 1H223.386V8.96875H217.229C214.354 8.96875 211.604 9.59375 208.979 10.8438C206.375 12.0938 204.427 14.1354 203.136 16.9688H223.386V24.9375Z"
                fill="transparent"
                stroke="white"
                stroke-width="1.5"
                stroke-linecap="round"
                stroke-linejoin="round"
            />

        </svg>

    </div>


    <header id="home" class="hero">
      <div class="nav-wrap">
        <nav class="nav">
          <div class="brand" aria-label="Sunrice Dental Clinic">
            <img src="images/logo1.png" alt="Sunrice Dental Clinic logo" class="brand-logo" />
            <div class="brand-text">
              <strong>Sunrise</strong>
              DENTAL CLINIC
            </div>
          </div>

          <div class="menu" id="primaryMenu" aria-label="Main Menu">
            <a href="#home">Home</a>
            <a href="#about">About</a>
            <a href="#services">Services</a>
            <a href="#gallery">Gallery</a>
            <a href="#contact">Contact</a>
          </div>

          <div class="nav-actions">
            <a class="login-btn" href="login.jsp">Login</a>
            <a class="nav-btn" href="#contact">view Appointment</a>
            <button class="menu-toggle" id="menuToggle" aria-label="Open navigation menu" aria-expanded="false">
              <span></span>
            </button>
          </div>
        </nav>
      </div>

      <div class="hero-inner">
        <div class="hero-copy" data-aos="fade-right" data-aos-duration="900">
          <h1>Smiles<br />That Last<br />a Lifetime</h1>
          <p>
            Advanced dental care with a gentle touch for a healthier, brighter smile
          </p>
          <a class="primary-btn" href="#contact">view Appointment</a>

          <div class="scroll-note">
            <span class="scroll-icon">↓</span>
            <span>Scroll to Explore</span>
          </div>
        </div>
      </div>
    </header>

    <main>
      <section id="about" class="about-section" data-aos="fade-up" data-aos-duration="800">
        <div class="section-kicker">Why choose us</div>
        <h2 class="section-title">Gentle care for every smile</h2>
        <div class="services-grid">
          <article class="service-card">
            <div class="service-icon">✓</div>
            <h3>Experienced Team</h3>
            <p>Highly trained dentists and specialists focused on patient comfort.</p>
          </article>

          <article class="service-card">
            <div class="service-icon">✦</div>
            <h3>Modern Technology</h3>
            <p>Advanced diagnostic tools and modern treatment methods for better results.</p>
          </article>

          <article class="service-card">
            <div class="service-icon">❤</div>
            <h3>Comfort First</h3>
            <p>A calm, welcoming clinic experience designed around your wellbeing.</p>
          </article>

          <article class="service-card">
            <div class="service-icon">◌</div>
            <h3>Personalized Care</h3>
            <p>Tailored treatment plans that match your goals and oral health needs.</p>
          </article>
        </div>
      </section>

      <section id="services" class="services" data-aos="fade-up" data-aos-duration="800">
        <div class="section-kicker">Premium Care</div>
        <h2 class="section-title">Our Dental Services</h2>

        <div class="services-grid">
          <article class="service-card" data-aos="zoom-in" data-aos-delay="50">
            <div class="service-icon">🦷</div>
            <h3>General Dentistry</h3>
            <p>Complete care for a healthy smile</p>
          </article>

          <article class="service-card" data-aos="zoom-in" data-aos-delay="100">
            <div class="service-icon">✦</div>
            <h3>Dental Implants</h3>
            <p>Permanent solutions for missing teeth</p>
          </article>

          <article class="service-card" data-aos="zoom-in" data-aos-delay="150">
            <div class="service-icon">✨</div>
            <h3>Cosmetic Dentistry</h3>
            <p>Enhance your smile with confidence</p>
          </article>

          <article class="service-card" data-aos="zoom-in" data-aos-delay="200">
            <div class="service-icon">◌</div>
            <h3>Orthodontics</h3>
            <p>Straighten your smile beautifully</p>
          </article>
        </div>
      </section>

      <section id="gallery" class="gallery-section" data-aos="fade-up" data-aos-duration="900">
        <div class="gallery-grid">
          <div class="section-kicker" style="color:#dfeefb;">Smile Transformations</div>
          <h2 class="section-title" style="color:#eff7ff; margin-bottom:0;">Real Smiles. Real Results.</h2>

          <div class="gallery-cards">
            <div class="gallery-card" data-aos="fade-right" data-aos-delay="100">
              <div class="brand-badge"><span class="mini-mark"></span>PureSmile</div>
            </div>
            <div class="gallery-card" data-aos="fade-up" data-aos-delay="150"></div>
            <div class="gallery-card" data-aos="fade-left" data-aos-delay="200"></div>
          </div>
        </div>

        <div class="callout">
          <div class="callout-copy" data-aos="fade-right" data-aos-duration="900">
            <div class="icon-wrap">✦</div>
            <h2>Your Smile,<br />Our Passion.</h2>
            <p>
              Experience personalized dental care in a calm and comfortable environment.
            </p>
            <span class="callout-badge">view Appointment →</span>
          </div>

          <div class="callout-visual" aria-label="Dental care banner" data-aos="fade-left" data-aos-duration="1000"></div>
        </div>
      </section>

      <section id="contact" class="contact-section" data-aos="fade-up" data-aos-duration="800">
        <div class="gallery-grid" style="padding-bottom: 40px;">
          <div class="section-kicker">Get in Touch</div>
          <h2 class="section-title">Contact & Consultation</h2>
          <div class="services-grid">
            <article class="service-card" data-aos="zoom-in" data-aos-delay="50">
              <div class="service-icon">☎</div>
              <h3>Call Us</h3>
              <p>+1 (800) 555-0199</p>
              <p class="contact-detail">Available Mon-Sat</p>
            </article>
            <article class="service-card" data-aos="zoom-in" data-aos-delay="100">
              <div class="service-icon">✉</div>
              <h3>Email</h3>
              <p>hello@sunrisedental.com</p>
              <p class="contact-detail">Response within 24hrs</p>
            </article>
            <article class="service-card" data-aos="zoom-in" data-aos-delay="150">
              <div class="service-icon">⏰</div>
              <h3>Hours</h3>
              <p>Mon - Sat: 9:00 AM - 7:00 PM</p>
              <p class="contact-detail">Emergency: 24/7</p>
            </article>
            <article class="service-card" data-aos="zoom-in" data-aos-delay="200">
              <div class="service-icon">📍</div>
              <h3>Location</h3>
              <p>24 Harbor Avenue, Dental District</p>
              <p class="contact-detail">Parking available</p>
            </article>
          </div>

          <div class="contact-form-wrapper" data-aos="fade-up" data-aos-delay="100">
            <h3>Schedule Your Appointment</h3>
            <p>Fill in your details and we'll get back to you within 24 hours</p>
            <form class="contact-form">
              <div class="form-group">
                <input type="text" placeholder="Your Name" required>
              </div>
              <div class="form-group">
                <input type="email" placeholder="Your Email" required>
              </div>
              <div class="form-group">
                <input type="tel" placeholder="Your Phone">
              </div>
              <div class="form-group">
                <select required>
                  <option value="">Select Service</option>
                  <option value="general">General Dentistry</option>
                  <option value="implants">Dental Implants</option>
                  <option value="cosmetic">Cosmetic Dentistry</option>
                  <option value="ortho">Orthodontics</option>
                </select>
              </div>
              <button type="submit" class="form-submit">view Appointment</button>
            </form>
          </div>
        </div>
      </section>
    </main>

    <footer class="footer">
      <div class="footer-content">
        <div class="footer-section">
          <div class="footer-brand">
            <img src="images/logo1.png" alt="Sunrice" class="footer-logo">
            <h4>Sunrise Dental Clinic</h4>
            <p>Providing exceptional dental care with a gentle touch and a smile.</p>
          </div>
        </div>

        <div class="footer-section">
          <h5>Quick Links</h5>
          <ul class="footer-links">
            <li><a href="#home">Home</a></li>
            <li><a href="#about">About Us</a></li>
            <li><a href="#services">Services</a></li>
            <li><a href="#gallery">Gallery</a></li>
          </ul>
        </div>

        <div class="footer-section">
          <h5>Services</h5>
          <ul class="footer-links">
            <li><a href="#services">General Dentistry</a></li>
            <li><a href="#services">Dental Implants</a></li>
            <li><a href="#services">Cosmetic Dentistry</a></li>
            <li><a href="#services">Orthodontics</a></li>
          </ul>
        </div>

        <div class="footer-section">
          <h5>Contact Info</h5>
          <ul class="footer-contact">
            <li>📞 +1 (800) 555-0199</li>
            <li>✉ hello@sunrisedental.com</li>
            <li>📍 24 Harbor Avenue, Dental District</li>
            <li>⏰ Mon-Sat: 9:00 AM - 7:00 PM</li>
          </ul>
        </div>
      </div>

      <div class="footer-bottom">
        <p>&copy; 2026 Sunrise Dental Clinic. All rights reserved.</p>
        <div class="footer-socials">
          <a href="#" class="social-link" title="Facebook">f</a>
          <a href="#" class="social-link" title="Instagram">📷</a>
          <a href="#" class="social-link" title="Twitter">𝕏</a>
        </div>
      </div>
    </footer>

    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script>
      AOS.init({
        duration: 800,
        once: true,
        offset: 40,
      });

      const menuToggle = document.getElementById('menuToggle');
      const primaryMenu = document.getElementById('primaryMenu');

      if (menuToggle && primaryMenu) {
        menuToggle.addEventListener('click', () => {
          const isOpen = primaryMenu.classList.toggle('is-open');
          menuToggle.setAttribute('aria-expanded', String(isOpen));
        });

        primaryMenu.querySelectorAll('a').forEach((link) => {
          link.addEventListener('click', () => {
            primaryMenu.classList.remove('is-open');
            menuToggle.setAttribute('aria-expanded', 'false');
          });
        });
      }
    </script>

    <script>

        window.addEventListener("load", function () {

            const loader = document.getElementById("intro-loader");
            const logo = document.getElementById("intro-logo");
            const path = document.getElementById("logo-path");

            // Add loader-active class to body to prevent scrolling
            document.body.classList.add('loader-active');

            // Make sure everything exists
            if (!loader || !logo || !path) {
                console.error("Intro loader elements not found.");
                document.body.classList.remove('loader-active');
                return;
            }


            /*
            ========================================
                GET REAL SVG PATH LENGTH
            ========================================
            */

            const length = path.getTotalLength();

            console.log("Logo path length:", length);


            /*
            ========================================
                INITIAL STATE
            ========================================
            */

            path.style.strokeDasharray = length;
            path.style.strokeDashoffset = length;

            path.style.fill = "transparent";


            /*
            ========================================
                DRAW LOGO
            ========================================
            */

            const drawAnimation = path.animate(

                [
                    {
                        strokeDashoffset: length
                    },

                    {
                        strokeDashoffset: 0
                    }
                ],

                {
                    duration: 3000,

                    easing: "ease-in-out",

                    fill: "forwards"
                }

            );


            /*
            ========================================
                AFTER DRAWING
                TURN INTO SOLID LOGO
            ========================================
            */

            drawAnimation.onfinish = function () {

                // Remove stroke animation effect
                path.style.strokeDasharray = "none";
                path.style.strokeDashoffset = "0";

                // Fade stroke away
                path.style.stroke = "transparent";

                // Fill logo
                path.style.fill = "white";

            };


            /*
            ========================================
                ZOOM LOGO
            ========================================
            */

            setTimeout(function () {

                loader.classList.add("zooming");

            }, 3700);


            /*
            ========================================
                HIDE LOADER
            ========================================
            */

            setTimeout(function () {

                loader.classList.add("hide");
                document.body.classList.remove('loader-active');
                document.documentElement.style.overflow = 'auto';
                document.body.style.overflow = 'auto';

            }, 4700);


            /*
            ========================================
                REMOVE LOADER
            ========================================
            */

            setTimeout(function () {

                loader.remove();

            }, 5500);

        });

    </script>


  </body>
</html>
