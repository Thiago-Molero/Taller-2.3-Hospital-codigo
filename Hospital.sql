



CREATE TABLE tPaciente (
    codP VARCHAR2(4) PRIMARY KEY,
    tipoDocP VARCHAR2(15),
    nroDocP VARCHAR2(12),
    paternoP VARCHAR2(50),
    maternoP VARCHAR2(50),
    nombresP VARCHAR2(50),
    fechaNacimientoP DATE,
    generoP CHAR(1)
);

CREATE TABLE tMedico (
    codM VARCHAR2(4) PRIMARY KEY,
    tipoDocM VARCHAR2(15),
    nroDocM VARCHAR2(12),
    paternoM VARCHAR2(50),
    maternoM VARCHAR2(50),
    nombresM VARCHAR2(50),
    celularM VARCHAR2(12),
    fechaNacimientoM DATE,
    generoM CHAR(1)
);

CREATE TABLE tEspecialidad (
    codEsp VARCHAR2(4) PRIMARY KEY,
    nombreEsp VARCHAR2(70),
    descripcionEsp VARCHAR2(100)
);

CREATE TABLE tEnfermedad (
    codE VARCHAR2(4) PRIMARY KEY,
    nombreE VARCHAR2(50),
    descripcionE VARCHAR2(100)
);

CREATE TABLE tDiagnostico (
    codD VARCHAR2(4) PRIMARY KEY,
    fechaHoraD TIMESTAMP, -- En Oracle usamos TIMESTAMP o DATE
    descripcionD VARCHAR2(100),
    codP VARCHAR2(4),
    codM VARCHAR2(4),
    FOREIGN KEY (codP) REFERENCES tPaciente (codP),
    FOREIGN KEY (codM) REFERENCES tMedico (codM)
);

CREATE TABLE tEspecialidadDelMedico (
    codEspM VARCHAR2(4) PRIMARY KEY,
    codEsp VARCHAR2(4),
    codM VARCHAR2(4),
    fechaDeObtencionDeLaEspecialidadEspM DATE,
    FOREIGN KEY (codEsp) REFERENCES tEspecialidad (codEsp),
    FOREIGN KEY (codM) REFERENCES tMedico (codM)
);

CREATE TABLE tEnfermedadEnElDiagnostico (
    codED VARCHAR2(4) PRIMARY KEY,
    codE VARCHAR2(4),
    codD VARCHAR2(4),
    FOREIGN KEY (codE) REFERENCES tEnfermedad (codE),
    FOREIGN KEY (codD) REFERENCES tDiagnostico (codD)
);


INSERT INTO tPaciente VALUES('P01', 'DNI', '11111111', 'Salas', 'Rivas', 'Juan', TO_DATE('2000-02-02', 'YYYY-MM-DD'), 'M'); 
INSERT INTO tPaciente VALUES('P02', 'DNI', '22222222', 'Pérez', 'Rozas', 'Elena', TO_DATE('2020-10-01', 'YYYY-MM-DD'), 'F'); 

INSERT INTO tMedico VALUES('M1', 'DNI','33333333', 'Zela', 'Ramírez', 'Javier', '999999999', TO_DATE('1970-10-10', 'YYYY-MM-DD'), 'M'); 
INSERT INTO tMedico VALUES('M2', 'Carnet','7777', 'Cabral', 'Desousa', 'Alejandra', '988888877', TO_DATE('1975-12-06', 'YYYY-MM-DD'), 'F'); 

INSERT INTO tEspecialidad VALUES('Esp1', 'Otorrinolaringología', 'Oídos, nariz y garganta');
INSERT INTO tEspecialidad VALUES('Esp2', 'Pediatría', 'Neonato, niño y adolescente'); 
INSERT INTO tEspecialidad VALUES('Esp3', 'Cardiología', 'Corazón, sistema circulatorio'); 
INSERT INTO tEspecialidad VALUES('Esp4', 'Odontología', 'Dientes, encías'); 

INSERT INTO tEnfermedad VALUES('E1', 'Alergia respiratoria', 'Alergias en el sistema respiratorio'); 
INSERT INTO tEnfermedad VALUES('E2', 'Sinusitis', 'Gripe crónica'); 
INSERT INTO tEnfermedad VALUES('E3', 'Artritis', 'Enfermedad crónica de los huesos'); 

INSERT INTO tDiagnostico VALUES('D1', TO_TIMESTAMP('2022-02-25 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Sinusitis aguda y alergia', 'P01', 'M1');
INSERT INTO tDiagnostico VALUES('D2', TO_TIMESTAMP('2022-02-28 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Niña sana', 'P02', 'M2'); 

INSERT INTO tEspecialidadDelMedico VALUES('EM1', 'Esp1', 'M1', TO_DATE('2010-12-12', 'YYYY-MM-DD')); 
INSERT INTO tEspecialidadDelMedico VALUES('EM2', 'Esp2', 'M2', TO_DATE('2009-02-02', 'YYYY-MM-DD')); 
INSERT INTO tEspecialidadDelMedico VALUES('EM3', 'Esp3', 'M2', TO_DATE('2019-11-21', 'YYYY-MM-DD')); 

INSERT INTO tEnfermedadEnElDiagnostico VALUES('ED1', 'E1', 'D1'); 
INSERT INTO tEnfermedadEnElDiagnostico VALUES('ED2', 'E2', 'D1');


COMMIT;






SELECT 
    p.codP, 
    p.nombresP, 
    p.paternoP, 
    p.maternoP, 
    d.codD, 
    d.descripcionD AS diagnostico, 
    e.nombreE AS enfermedad
FROM tpaciente p
-- Conectamos paciente con sus diagnósticos
JOIN tdiagnostico d 
    ON p.codP = d.codP 
-- Conectamos el diagnóstico con la tabla intermedia de enfermedades
JOIN tenfermedadeneldiagnostico ed 
    ON d.codD = ed.codD 
-- Finalmente obtenemos el nombre de la enfermedad
JOIN tenfermedad e 
    ON ed.codE = e.codE;
    
    
    
    
    
    
    
CREATE OR REPLACE VIEW v_pacienteEnfermedad (
    codigoP, 
    nombresP, 
    paternoP, 
    maternoP, 
    codigoD, 
    nombreD, 
    nombreE
) AS 
SELECT 
    p.codP, 
    p.nombresP, 
    p.paternoP, 
    p.maternoP, 
    d.codD, 
    d.descripcionD, 
    e.nombreE 
FROM tpaciente p
JOIN tdiagnostico d ON p.codP = d.codP 
JOIN tenfermedadeneldiagnostico ed ON d.codD = ed.codD 
JOIN tenfermedad e ON ed.codE = e.codE;




SELECT 
    COUNT(*) AS cantidad_de_enfermedades, 
    nombresP, 
    paternoP, 
    maternoP 
FROM v_pacienteEnfermedad 
GROUP BY nombresP, paternoP, maternoP;



-- 5.1
CREATE OR REPLACE VIEW v_MedicoEspecialidad AS
SELECT 
    m.codM, 
    m.nombresM, 
    m.paternoM, 
    m.maternoM, 
    e.nombreEsp
FROM tMedico m
JOIN tEspecialidadDelMedico em ON m.codM = em.codM
JOIN tEspecialidad e ON em.codEsp = e.codEsp;

--5.2
SELECT nombresM, paternoM, COUNT(*) AS cantidad_especialidades
FROM v_MedicoEspecialidad
GROUP BY nombresM, paternoM;

--5.3
SELECT nombresM, paternoM, COUNT(*) AS cantidad_especialidades
FROM v_MedicoEspecialidad
GROUP BY nombresM, paternoM
HAVING COUNT(*) >= 2;

--5.4
CREATE OR REPLACE VIEW v_EnfermedadesNoDetectadas AS
SELECT e.codE, e.nombreE
FROM tEnfermedad e
LEFT JOIN tEnfermedadEnElDiagnostico ed ON e.codE = ed.codE
WHERE ed.codE IS NULL;

--5.5
CREATE OR REPLACE VIEW v_EspecialidadesSinMedico AS
SELECT e.codEsp, e.nombreEsp
FROM tEspecialidad e
LEFT JOIN tEspecialidadDelMedico em ON e.codEsp = em.codEsp
WHERE em.codEsp IS NULL;

--5.6
SELECT COUNT(*) AS total_especialidades_vacias 
FROM v_EspecialidadesSinMedico;

--5.7
CREATE OR REPLACE VIEW v_PacientesSinEnfermedad AS
SELECT DISTINCT p.nombresP, p.paternoP, d.codD, d.descripcionD
FROM tPaciente p
JOIN tDiagnostico d ON p.codP = d.codP
LEFT JOIN tEnfermedadEnElDiagnostico ed ON d.codD = ed.codD
WHERE ed.codD IS NULL;