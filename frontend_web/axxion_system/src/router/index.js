//create web sirve para un histoial de las vistas mas visitadas
import { createRouter, createWebHistory } from 'vue-router'
import Home from '/src/views/Home.vue'
import User from '@/views/User.vue'
import Login from '@/views/login.vue'


const routes = [
    {
    path: '/login',
    name: 'login',
    component: Login,
    meta: { requiresAuth: false },
  },
  {
    path: '/Home',
    name: 'Home',
    component: Home,
    meta: { requiresAuth: false },
  },
   {
    path: '/User',
    name: 'usuarios',
    component: User,
    meta: { requiresAuth: false },
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

router.beforeEach((to, from, next) => {
  const requiresAuth = to.matched.some((record) => record.meta.requiresAuth)
  const isLogged = !!localStorage.getItem('authToken')

  if (requiresAuth && !isLogged) {
    next('/login')
  } else {
    next()
  }
})

export default router
