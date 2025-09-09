import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import './Style.css'
import { library } from '@fortawesome/fontawesome-svg-core'
import { fas } from '@fortawesome/free-solid-svg-icons'
/* import all the icons in Free Solid, Free Regular, and Brands styles */
import { far } from '@fortawesome/free-regular-svg-icons'
import { fab } from '@fortawesome/free-brands-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import axios from 'axios'
import { createPinia } from 'pinia'
library.add(fas, far, fab)

const app = createApp(App)
app.use(createPinia())
app. component ('font-awesome-icon' , FontAwesomeIcon)

app.use(router)

app.mount('#app')

