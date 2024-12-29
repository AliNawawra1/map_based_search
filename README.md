# 📍 **Map-Based Search Task**

*A Flutter Application for Interactive Map-Based Search*

---

## 🚀 **Project Overview**

This Flutter application integrates **Google Maps** with dynamic search functionality, allowing
users to:

- 🗺️ **Search for locations dynamically.**
- 📍 **View and interact with custom markers on the map.**
- 🔌 **Access cached data in offline mode.**

The backend is powered by **FastAPI** with **MongoDB**, enabling robust and scalable API services.

---

## ✨ **Key Features**

### 🗺️ **Google Maps Integration**

- Interactive maps with customizable styles.

### 🔎 **Dynamic Search with Caching**

- Fast, efficient location searches optimized with **LRU Cache** and **Bloom Filter**, reducing API
  calls and ensuring high performance.

### 📴 **Offline Mode**

- Seamless offline experience using intelligent caching for recently searched data.

### 📡 **Connectivity Monitoring**

- Real-time online/offline status detection using `connectivity_plus`.

### 📐 **Responsive UI**

- Consistent user experience across devices and screen sizes.

### 🌐 **Scalable Backend**

- **FastAPI** framework for building RESTful APIs.
- **MongoDB** for flexible and efficient data storage.

---

## 🛠️ **Architecture Highlights**

### 🔄 **Optimized Caching**

- **LRU Cache**: Manages in-memory data efficiently, evicting the least recently used entries.
- **Bloom Filter**: Probabilistic filtering minimizes unnecessary cache lookups and API calls.

### 🧩 **Modular Design**

- Follows a feature-based architecture with clear separation of concerns, ensuring maintainability
  and scalability.

### 🔌 **Backend Integration**

- Built with **FastAPI** for high-performance Python APIs.
- Stores location data in **MongoDB**, enabling flexible schema design and efficient queries.

---

## ✨ **Key Design Patterns**

- **Repository Pattern**: Abstracts data access logic, ensuring scalability and testability.
- **Caching Strategy**: Combines **LRU Cache** and **Bloom Filter** for efficient search
  optimization.
- **Dependency Inversion Principle**: Controllers depend on abstractions (
  `LocationRepositoryInterface`) rather than concrete implementations.
- **Controller Pattern**: Handles interaction between the UI and data layers, maintaining a clean
  separation of concerns.

---

## 📱 **User Features**

- 🗺️ **Interactive Map**: Explore and interact with dynamically displayed locations.
- 🔎 **Dynamic Search**: Quickly locate places with optimized caching for responsiveness.
- 📴 **Offline Mode**: Access previously searched data without an internet connection.
- 📐 **Responsive Design**: Enjoy a seamless experience on any device.

---

## ⚙️ **Technical Insights**

### **LRU Cache**

- Uses a hashmap and doubly linked list to provide O(1) retrieval and eviction times.

### **Bloom Filter**

- A probabilistic data structure to efficiently check membership, reducing unnecessary API calls.

### **FastAPI**

- High-performance Python framework for RESTful APIs, ensuring scalability and fast response times.

### **MongoDB**

- A NoSQL database chosen for its flexible schema design and scalability.

---

## 🛠️ **Tech Stack**

- **Frontend**: Flutter
- **Backend**: FastAPI (Python), MongoDB
- **Caching**: LRU Cache, Bloom Filter
- **Maps**: Google Maps API
- **State Management**: GetX

---

## 👨‍💻 **Author**

Developed By: **[Ali Nawawra]**
