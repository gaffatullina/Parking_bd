-- ВЛАДЕЛЬЦЫ
CREATE TABLE IF NOT EXISTS Owners (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(40) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    registration_date DATE DEFAULT CURRENT_DATE
);

-- АВТОМОБИЛИ
CREATE TABLE IF NOT EXISTS Cars (
    id SERIAL PRIMARY KEY,
    owner_id INTEGER NOT NULL REFERENCES Owners(id),
    brand VARCHAR(100) NOT NULL,
    model VARCHAR(200) NOT NULL,
    license_plate VARCHAR(20) UNIQUE NOT NULL
);

-- ОХРАННИКИ
CREATE TABLE IF NOT EXISTS Guards (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(40) UNIQUE NOT NULL,
    schedule TEXT NOT NULL
);

-- ПЛАТЕЖИ
CREATE TABLE IF NOT EXISTS Payments (
    id SERIAL PRIMARY KEY,
    owner_id INTEGER NOT NULL REFERENCES Owners(id),
    status VARCHAR(20) CHECK (status IN ('оплачено', 'просрочено')),
    amount DECIMAL(10,2) NOT NULL
);

-- ЖУРНАЛ ПОСЕЩЕНИЙ
CREATE TABLE IF NOT EXISTS Logs (
    id SERIAL PRIMARY KEY,
    car_id INTEGER NOT NULL REFERENCES Cars(id),
    guard_id INTEGER NOT NULL REFERENCES Guards(id),
    entry_time TIMESTAMP NOT NULL,
    exit_time TIMESTAMP
);

-- ВЕРСИОННАЯ ТАБЛИЦА ПАРКОВОЧНЫХ МЕСТ (SCD TYPE 2)
CREATE TABLE IF NOT EXISTS Parking_spots (
    id SERIAL PRIMARY KEY,
    car_id INTEGER REFERENCES Cars(id),
    spot_number INTEGER NOT NULL,
    spot_type VARCHAR(22) CHECK (spot_type IN ('обычное', 'увеличенное')),
    status VARCHAR(20) CHECK (status IN ('свободно', 'занято', 'на обслуживании')),

    valid_from TIMESTAMP NOT NULL,
    valid_to TIMESTAMP,
    is_current BOOLEAN NOT NULL DEFAULT true,

    UNIQUE (spot_number, is_current) -- чтобы не было двух активных записей на одно место
);