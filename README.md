# GigsHub - Freelance Marketplace

A full-stack freelance marketplace application built with the MERN stack, inspired by Fiverr. Users can buy and sell services (gigs), communicate through messages, and process payments in INR.

## 🚀 Live Demo

- **Frontend:** [https://gigs-hub-one.vercel.app](https://gigs-hub-one.vercel.app)
- **Backend API:** [https://gigshub-jy7k.onrender.com](https://gigshub-jy7k.onrender.com)

## Screenshots
<img width="1503" height="702" alt="image" src="https://github.com/user-attachments/assets/214b7ac2-cefb-4015-bac9-d418f735a8b5" />
<img width="1477" height="765" alt="image" src="https://github.com/user-attachments/assets/848821cf-4051-415c-94c1-72ff9e46130b" />
<img width="1486" height="764" alt="image" src="https://github.com/user-attachments/assets/22b6c708-63bb-4a47-93fb-8e871735997f" />
<img width="1444" height="778" alt="image" src="https://github.com/user-attachments/assets/5a83a501-853c-4ab7-8605-37238bac5625" />
<img width="1429" height="722" alt="image" src="https://github.com/user-attachments/assets/33b295ee-95c7-4f42-9220-13e2bd396cfb" />
<img width="1421" height="775" alt="image" src="https://github.com/user-attachments/assets/004940e4-3f62-42ba-b65f-aed2aca23b29" />

## ✨ Features

- **User Authentication** - Register and login with JWT authentication
- **Browse Gigs** - Search and filter freelance services by category, price, and popularity
- **Create Gigs** - Sellers can create and manage their service listings
- **Orders System** - Complete order management for buyers and sellers
- **Real-time Messaging** - Chat between buyers and sellers
- **Payment Integration** - Stripe payment processing in INR (Indian Rupees)
- **Image Upload** - Cloudinary integration for gig images
- **Reviews & Ratings** - Leave reviews for completed orders
- **Responsive Design** - Mobile-friendly interface

## 🛠️ Tech Stack

### Frontend
- **React** - UI library
- **Vite** - Build tool
- **React Router** - Navigation
- **React Query** - Data fetching and caching
- **Axios** - HTTP client
- **Sass** - CSS preprocessor
- **Stripe** - Payment processing

### Backend
- **Node.js** - Runtime environment
- **Express** - Web framework
- **MongoDB** - Database
- **Mongoose** - ODM
- **JWT** - Authentication
- **Bcrypt** - Password hashing
- **Stripe** - Payment API

### Cloud Services
- **Vercel** - Frontend hosting
- **Render** - Backend hosting
- **MongoDB Atlas** - Database hosting
- **Cloudinary** - Image storage

## 📦 Installation

### Prerequisites
- Node.js (v14 or higher)
- MongoDB
- Cloudinary account
- Stripe account

### Clone Repository
```bash
git clone https://github.com/JainamSavla/GigsHub.git
cd GigsHub
```

### Backend Setup
```bash
cd api
npm install

# Create .env file with the following variables:
MONGO=your_mongodb_connection_string
JWT_KEY=your_jwt_secret
STRIPE=your_stripe_secret_key
FRONTEND_URL=http://localhost:5173
NODE_ENV=development
```

### Frontend Setup
```bash
cd client
npm install

# Create .env file with the following variables:
VITE_API_URL=http://localhost:8800/api
VITE_UPLOAD_LINK=your_cloudinary_upload_url
VITE_STRIPE_PUBLIC_KEY=your_stripe_public_key
```

## 🚀 Running Locally

### Start Backend
```bash
cd api
npm start
# Server runs on http://localhost:8800
```

### Start Frontend
```bash
cd client
npm run dev
# App runs on http://localhost:5173
```

## 📝 Environment Variables

### Backend (.env)
| Variable | Description |
|----------|-------------|
| `MONGO` | MongoDB connection string |
| `JWT_KEY` | Secret key for JWT tokens |
| `STRIPE` | Stripe secret key |
| `FRONTEND_URL` | Frontend URL for CORS |
| `NODE_ENV` | Environment (development/production) |

### Frontend (.env)
| Variable | Description |
|----------|-------------|
| `VITE_API_URL` | Backend API URL |
| `VITE_UPLOAD_LINK` | Cloudinary upload URL |
| `VITE_STRIPE_PUBLIC_KEY` | Stripe publishable key |

## 🌐 Deployment

### Frontend (Vercel)
1. Import project from GitHub
2. Set **Root Directory** to `client`
3. Add environment variables
4. Deploy

### Backend (Render)
1. Create new Web Service
2. Set **Root Directory** to `api`
3. Set **Build Command**: `npm install`
4. Set **Start Command**: `npm start`
5. Add environment variables
6. Deploy

## 💳 Payment Integration

This app uses Stripe for payment processing with INR currency. All prices are displayed with the ₹ symbol.

## 🖼️ Image Upload

Images are uploaded to Cloudinary using the upload preset configured in your Cloudinary account.

## 📱 API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `POST /api/auth/logout` - Logout user

### Gigs
- `GET /api/gigs` - Get all gigs
- `GET /api/gigs/:id` - Get single gig
- `POST /api/gigs` - Create gig (seller only)
- `DELETE /api/gigs/:id` - Delete gig (seller only)

### Orders
- `GET /api/orders` - Get user orders
- `POST /api/orders/create-payment-intent/:id` - Create payment intent
- `PUT /api/orders` - Confirm order

### Messages
- `GET /api/messages/:id` - Get conversation messages
- `POST /api/messages` - Send message

### Reviews
- `GET /api/reviews/:gigId` - Get gig reviews
- `POST /api/reviews` - Create review

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is open source and available under the MIT License.

## 👨‍💻 Author

**Jainam Savla**
- GitHub: [@JainamSavla](https://github.com/JainamSavla)

## 🙏 Acknowledgments

- Inspired by Fiverr
- Built following MERN stack best practices
- Thanks to all contributors and supporters
