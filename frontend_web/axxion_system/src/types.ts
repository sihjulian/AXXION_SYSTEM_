
export interface User {
  nombre_usuario: string;
  nombre: string;
  nombre2?: string;
  apellido1: string;
  apellido2?: string;
  email: string;
  telefono: string;
  departamento: string;
  estado: 'activo' | 'inactivo';
  photo?: string;
  bio: string;
  location: string;
}
