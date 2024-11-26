# Energy Trading DApp with Truffle

This project is a decentralized energy trading platform built using Solidity, Truffle, and React. It allows users to mint tokens, list energy for sale, and purchase energy in a decentralized marketplace.

---

## Prerequisites

Before setting up the project, ensure you have the following installed:

- **Node.js** (version 14 or higher)
- **npm** or **yarn**
- **Truffle** for smart contract development and deployment
- **Ganache** (for a local blockchain) or access to an Ethereum testnet

---

## Installation

1. **Clone the repository** and navigate to the project directory:

    ```bash
    git clone https://github.com/DDosszhan/DApp-EnergyTrading.git
    cd DApp-EnergyTrading
    ```

2. **Install dependencies**:

    ```bash
    npm install
    ```

3. **Compile the smart contracts**:

    ```bash
    truffle compile
    ```

4. **Start a local blockchain** (e.g., Ganache):

    ```bash
    ganache-cli
    ```

5. **Deploy the smart contracts** to the local blockchain:

    ```bash
    truffle migrate --network development
    ```

6. **Navigate to the frontend** `client` directory, install frontend dependencies, and start the app:

    ```bash
    cd energy-trading
    npm install
    npm start
    ```

   The app will run locally at `http://localhost:3000`.

7. **Navigate to the backend** `client` directory,  and start the app:
    ```bash
    cd energy-trading
    node server.js
    ```
    The app will run locally at `http://localhost:5000`.

8. **Replace the Gemini API Key**:

   To enable Gemini API functionality, you need to add your Gemini API key to the environment configuration. 

   - In the backend root directory, create a `.env` file:
     
     ```bash
     touch .env
     ```

   - Open the `.env` file and add the following line, replacing `YOUR_GEMINI_API_KEY` and `YOUR_GEMINI_API_SECRET` with your actual Gemini API credentials:

     ```plaintext
     GEMINI_API_KEY=YOUR_GEMINI_API_KEY
     GEMINI_API_SECRET=YOUR_GEMINI_API_SECRET
     ```

   - Save the file. Your backend will now be able to access Gemini's API using the credentials you provided.
   
   **Important**: Never share your `.env` file or your API keys in public repositories.

9. **Configure the PostgreSQL Database**:

   To set up and configure a PostgreSQL database for the backend, follow these steps:

   - **Install PostgreSQL**: If you don't already have PostgreSQL installed, follow the instructions for your operating system [here](https://www.postgresql.org/download/).

   - **Create a Database**: Open your PostgreSQL client (e.g., `psql`) and create a new database for the project:

     ```sql
     CREATE DATABASE energy_trading;
     ```
     ```sql
     -- Create the user energy balance table
      CREATE TABLE users (
          wallet VARCHAR(255) PRIMARY KEY,
          energy_balance NUMERIC DEFAULT 0
      );
     
      -- Create the transaction history table
      CREATE TABLE history (
          id SERIAL PRIMARY KEY,
          wallet VARCHAR(255) REFERENCES users(wallet),
          energy_balance NUMERIC,
          timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
      );
     ```

   - **Create a `.env` file** (if not already done) in the backend root directory and add your PostgreSQL connection details:

     ```bash
     touch .env
     ```

   - Open the `.env` file and add the following lines, replacing the placeholders with your actual database credentials:

     ```plaintext
     POSTGRES_USER=your_postgres_username
     POSTGRES_PASSWORD=your_postgres_password
     POSTGRES_DB=energy_trading
     POSTGRES_HOST=localhost
     POSTGRES_PORT=5432
     ```

   - **Install PostgreSQL dependencies**: If your backend requires a PostgreSQL client, install it using `npm`:

     ```bash
     npm install pg
     ```

   - **Initialize the Database**: If your application includes a database migration or initialization script, run it to set up the database schema:

     ```bash
     npx sequelize-cli db:migrate   # Example using Sequelize, modify if using a different ORM
     ```

   Your PostgreSQL database is now configured and ready to use with the backend.

this is how analytics looks like:
![image](https://github.com/user-attachments/assets/92348fb1-e364-4ced-97d7-447932bdacc4)

   
   **Note**: Ensure that your `.env` file is kept secure and not shared in public repositories.


---
press "get analytics" to get this output:
![image](https://github.com/user-attachments/assets/2d19c1fa-7d6c-4089-acf9-160221463672)


This the main page, appearing for trading

![image](https://github.com/user-attachments/assets/55bd2cdd-9e60-46d5-9dab-feb469547b82)


This completes the setup and deployment of the project using Truffle. For further instructions, please refer to the rest of the documentation.
