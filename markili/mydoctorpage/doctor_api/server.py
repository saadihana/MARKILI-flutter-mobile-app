from quart import Quart, request, jsonify
from quart_cors import cors
import asyncpg
from datetime import datetime, time
import logging

app = Quart(__name__)
app = cors(app, allow_origin="*")

temp_doctor_registrations = {}
temp_patient_registrations = {}

pool = None

# PostgreSQL database configuration
DB_CONFIG = {
    'database': 'mobdevproject',
    'user': 'postgres',
    'password': 'moussa123',
    'host': 'localhost',
    'port': 5432
}

# Async function to get database connection
async def get_db_connection():
    return await asyncpg.connect(
        database=DB_CONFIG['database'],
        user=DB_CONFIG['user'],
        password=DB_CONFIG['password'],
        host=DB_CONFIG['host'],
        port=DB_CONFIG['port']
    )


loop = asyncio.new_event_loop()
asyncio.set_event_loop(loop)
loop.run_until_complete(init_db())

# Doctor signup steps
@app.route('/signup/doctor/step1', methods=['POST'])
def signup_doctor_step1():
    data = request.get_json()
    print("Received step 1 data:", data)

    async def _signup_step1():
        async with pool.acquire() as conn:
            # Check if email exists
            existing_doctor = await conn.fetchval(
                'SELECT COUNT(*) FROM doctor WHERE email = $1',
                data.get('email')
            )
            if existing_doctor:
                return {"error": "Email already registered"}, 400

            # Store step 1 data temporarily
            temp_doctor_registrations[data['email']] = {
                'name': data['name'],
                'surname': data['surname'],
                'email': data['email'],
                'password': data['password']
            }
            
            return {"message": "Step 1 completed successfully"}, 200

    try:
        result, status = loop.run_until_complete(_signup_step1())
        return jsonify(result), status
    except Exception as e:
        print(f"Error in step 1: {e}")
        return jsonify({"error": str(e)}), 500

@app.route('/signup/doctor/step2', methods=['POST'])
def signup_doctor_step2():
    data = request.get_json()
    print("Received step 2 data:", data)

    async def _signup_step2():
        try:
            email = data.get('email')  # You'll need to pass the email in step 2
            if email not in temp_doctor_registrations:
                return {"error": "Step 1 data not found. Please complete step 1 first."}, 400

            step1_data = temp_doctor_registrations[email]
            
            async with pool.acquire() as conn:
                # Insert complete doctor data
                await conn.execute('''
                    INSERT INTO doctor (name, surname, email, password, speciality, address, phonenumber, description)
                    VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
                ''', 
                    step1_data['name'],
                    step1_data['surname'],
                    step1_data['email'],
                    step1_data['password'],
                    data['speciality'],
                    data['address'],
                    data['phone'],
                    data['description']
                )

                # Clean up temporary storage
                del temp_doctor_registrations[email]
                
                return {"message": "Doctor registration successful"}, 201

        except Exception as e:
            print(f"Error in step 2: {e}")
            return {"error": str(e)}, 500

    try:
        result, status = loop.run_until_complete(_signup_step2())
        return jsonify(result), status
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({"error": str(e)}), 500

# Patient signup steps
@app.route('/signup/patient', methods=['POST'])
def signup_patient():
    data = request.get_json()
    print("Received patient signup data:", data)

    async def _signup():
        try:
            async with pool.acquire() as conn:
                # Check if email exists
                existing_patient = await conn.fetchval(
                    'SELECT COUNT(*) FROM patients WHERE email = $1',
                    data.get('email')
                )
                if existing_patient:
                    return {"error": "Email already registered"}, 400

                # Insert patient data directly into database
                await conn.execute('''
                    INSERT INTO patients (name, surname, email, password)
                    VALUES ($1, $2, $3, $4)
                ''',
                    data['name'],
                    data['surname'],
                    data['email'],
                    data['password']
                )
                
                return {"message": "Patient registration successful"}, 201

        except Exception as e:
            print(f"Error in patient signup: {e}")
            return {"error": str(e)}, 500

    try:
        result, status = loop.run_until_complete(_signup())
        return jsonify(result), status
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({"error": str(e)}), 500

# Keep the login endpoints as they are
@app.route('/login/doctor', methods=['POST'])
def login_doctor():
    data = request.get_json()

    async def _login():
        async with pool.acquire() as conn:
            user = await conn.fetchrow(
                "SELECT DoctorId, Name, Surname, Speciality FROM Doctor WHERE Email = $1 AND Password = $2",
                data.get('email'),
                data.get('password')
            )
            if user:
                return {"message": "Login successful", "user": dict(user)}, 200
            return {"error": "Invalid email or password"}, 401

    try:
        result, status = loop.run_until_complete(_login())
        return jsonify(result), status
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/login/patient', methods=['POST'])
def login_patient():
    data = request.get_json()

    async def _login():
        async with pool.acquire() as conn:
            user = await conn.fetchrow(
                "SELECT PatientId, Name, Surname FROM patients WHERE Email = $1 AND Password = $2",
                data.get('email'),
                data.get('password')
            )
            if user:
                return {"message": "Login successful", "user": dict(user)}, 200
            return {"error": "Invalid email or password"}, 401

    try:
        result, status = loop.run_until_complete(_login())
        return jsonify(result), status
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/doctors', methods=['GET'])
async def get_doctors():
    try:
        conn = await get_db_connection()
        doctors = await conn.fetch("SELECT * FROM Doctor")
        await conn.close()

        doctor_list = [dict(record) for record in doctors]
        return jsonify(doctor_list)
    except Exception as e:
        print(f"Error fetching doctors: {e}")
        return jsonify({'error': 'Internal Server Error'}), 500
    
# Route to fetch and modify timeslots
@app.route('/timeslots', methods=['GET'])
async def get_timeslots():
    try:
        doctor_id = request.args.get('doctorid')
        date_str = request.args.get('date')  # 'yyyy-mm-dd'
        slot = request.args.get('slot')  # Time slot to add/remove
        action = request.args.get('action')  # 'add' or 'remove'

        if not doctor_id or not date_str:
            return jsonify({'error': 'Missing required fields (doctorid and date)'}), 400

        doctor_id = int(doctor_id)

        # Parse the date string to a date object
        try:
            query_date = datetime.strptime(date_str, "%Y-%m-%d").date()
        except ValueError:
            return jsonify({'error': 'Invalid date format, expected YYYY-MM-DD'}), 400

        conn = await get_db_connection()

        # Check if a row exists for the doctor and date
        query = "SELECT busyslots FROM TimeSlots WHERE doctorid = $1 AND date = $2"
        result = await conn.fetchrow(query, doctor_id, query_date)

        if not result:
            # Create a new entry if it does not exist
            insert_query = "INSERT INTO TimeSlots (doctorid, date, busyslots) VALUES ($1, $2, $3)"
            await conn.execute(insert_query, doctor_id, query_date, [])
            result = {'busyslots': []}

        busy_slots = result['busyslots'] or []

        # Handle slot addition/removal
        if slot and action:
            try:
                # Convert slot string to a time object
                slot_time = datetime.strptime(slot, "%H:%M").time()

                if action == 'add':
                    if slot_time not in busy_slots:
                        busy_slots.append(slot_time)
                elif action == 'remove':
                    if slot_time in busy_slots:
                        busy_slots.remove(slot_time)
                else:
                    return jsonify({'error': 'Invalid action, expected "add" or "remove"'}), 400

                # Update the database with the modified busy slots
                update_query = "UPDATE TimeSlots SET busyslots = $1 WHERE doctorid = $2 AND date = $3"
                await conn.execute(update_query, busy_slots, doctor_id, query_date)
            except ValueError:
                return jsonify({'error': 'Invalid slot time format, expected HH:MM'}), 400

        await conn.close()

        return jsonify({'success': True, 'busyslots': [str(t) for t in busy_slots]})

    except Exception as e:
        return jsonify({'error': 'Internal Server Error', 'message': str(e)}), 500
    
    
@app.route('/book_appointment', methods=['POST'])
async def book_appointment():
    try:
        data = await request.get_json()
        patientid = data.get('patientid')
        doctorid = data.get('doctorid')
        date = data.get('date')
        slot = data.get('slot')

        if not all([patientid, doctorid, date, slot]):
            return jsonify({'success': False, 'message': 'Missing parameters'}), 400

        appointment_time = datetime.strptime(f"{date} {slot}", "%Y-%m-%d %H:%M")

        conn = await get_db_connection()
        query = """
        SELECT COUNT(*) FROM appointments
        WHERE doctorid = $1 AND appointmenttime = $2
        """
        count = await conn.fetchval(query, doctorid, appointment_time)

        if count > 0:
            return jsonify({'success': False, 'message': 'Slot already booked'}), 400

        insert_query = """
        INSERT INTO appointments (patientid, doctorid, appointmenttime, status)
        VALUES ($1, $2, $3, 'Pending')
        """
        await conn.execute(insert_query, patientid, doctorid, appointment_time)
        await conn.close()

        return jsonify({'success': True, 'message': 'Appointment booked successfully'}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500

# page PatientScreen

#getting name and surname of patient
@app.route('/patient', methods=['GET'])
async def get_patient():
    try:
        patient_id = request.args.get('patientid')
        if not patient_id:
            return jsonify({'error': 'Missing patient ID'}), 400

        conn = await get_db_connection()
        query = "SELECT name, surname FROM patients WHERE id = $1"
        patient = await conn.fetchrow(query, int(patient_id))
        await conn.close()

        if patient:
            full_name = f"{patient['name']} {patient['surname']}"
            return jsonify({'name': full_name}), 200
        return jsonify({'error': 'Patient not found'}), 404

    except Exception as e:
        print(f"Error in get_patient: {e}")
        return jsonify({'error': str(e)}), 500
    

#modifying patient info

@app.route('/update_patient/<int:patient_id>', methods=['PUT'])
async def update_patient(patient_id):
    try:
        data = await request.get_json()
        conn = await get_db_connection()
        
        result = await conn.execute("""
            UPDATE Patient 
            SET name = $1, 
                surname = $2
            WHERE patientid = $3
            """,
            data.get('name'),
            data.get('surname'),
            patient_id
        )
        
        await conn.close()
        
        if result == "UPDATE 1":
            return jsonify({'message': 'Patient updated successfully'})
        return jsonify({'error': 'Patient not found'}), 404
    except Exception as e:
        print(f"Error updating patient: {e}")
        return jsonify({'error': 'Internal Server Error'}), 500

#getting info for the table of appoitment
@app.route('/patient_appointments', methods=['GET'])
async def get_patient_appointments():
    try:
        patient_id = request.args.get('patientid')

        if not patient_id:
            return jsonify({'error': 'Missing patient ID'}), 400

        conn = await get_db_connection()

        query = """
        SELECT 
            a.appointmenttime, 
            d.surname AS doctor_name, 
            d.speciality, 
            d.address
        FROM appointments a
        JOIN doctor d ON a.doctorid = d.doctorid
        WHERE a.patientid = $1
        ORDER BY a.appointmenttime;
        """

        records = await conn.fetch(query, int(patient_id))
        await conn.close()

        appointments = []
        for record in records:
            appointment = dict(record)
            # Convert datetime to string for JSON serialization
            appointment['appointmenttime'] = appointment['appointmenttime'].isoformat()
            appointments.append(appointment)

        return jsonify(appointments), 200

    except Exception as e:
        logging.error(f"Error in get_patient_appointments: {str(e)}")
        return jsonify({'error': str(e)}), 500
    

# page doctor modify info
'''
@app.route('/doctor', methods=['GET'])
async def get_doctor():
    try:
        doctor_id = request.args.get('doctorid', 1)
        conn = await get_db_connection()
        query = "SELECT * FROM doctor WHERE doctorid = $1"
        doctor = await conn.fetchrow(query, int(doctor_id))
        await conn.close()
        
        if doctor:
            return jsonify(dict(doctor)), 200
        return jsonify({'error': 'Doctor not found'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/doctor/update', methods=['POST'])
async def update_doctor():
    try:
        data = await request.get_json()
        doctor_id = data.get('doctorid', 1)
        
        conn = await get_db_connection()
        query = """
            UPDATE doctor 
            SET name = $1, speciality = $2, phonenumber = $3, 
                address = $4, email = $5, description = $6
            WHERE doctorid = $7
            RETURNING *
        """
        updated = await conn.fetchrow(
            query, 
            data['name'],
            data['speciality'],
            data['phonenumber'],
            data['address'],
            data['email'],
            data['description'],
            doctor_id
        )
        await conn.close()
        
        return jsonify(dict(updated)), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
'''

@app.route('/doctors/<int:doctor_id>', methods=['GET'])
async def get_doctor(doctor_id):
    try:
        conn = await get_db_connection()
        doctor = await conn.fetchrow(
            """
            SELECT doctorid, name, surname, email, speciality, 
                   address, phonenumber, description 
            FROM Doctor 
            WHERE doctorid = $1
            """, 
            doctor_id
        )
        await conn.close()
        
        if doctor:
            return jsonify(dict(doctor))
        return jsonify({'error': 'Doctor not found'}), 404
    except Exception as e:
        print(f"Error fetching doctor: {e}")
        return jsonify({'error': 'Internal Server Error'}), 500

@app.route('/doctors/<int:doctor_id>', methods=['PUT'])
async def update_doctor(doctor_id):
    try:
        data = await request.get_json()
        conn = await get_db_connection()
        
        # Update doctor information
        result = await conn.execute("""
            UPDATE Doctor 
            SET surname = $1, 
                speciality = $2,
                phonenumber = $3,
                address = $4,
                email = $5,
                description = $6
            WHERE doctorid = $7
            """,
            data.get('surname'),
            data.get('speciality'),
            data.get('phonenumber'),
            data.get('address'),
            data.get('email'),
            data.get('description'),
            doctor_id
        )
        
        await conn.close()
        
        if result == "UPDATE 1":
            return jsonify({'message': 'Doctor profile updated successfully'})
        return jsonify({'error': 'Doctor not found'}), 404
    except Exception as e:
        print(f"Error updating doctor: {e}")
        return jsonify({'error': 'Internal Server Error'}), 500


import asyncio

if __name__ == "__main__":
    asyncio.run(app.run_task(host="0.0.0.0", port=5001))

