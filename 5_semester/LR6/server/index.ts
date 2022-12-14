import * as express from 'express'
import { Express } from 'express'
import { Sequelize, QueryTypes } from 'sequelize'
import { AuthorizationResponse, CheckAuthorizationBody } from './types'
import { isAuthorized } from './utils'
import { UNAUTHORIZED_STRING_MESSAGE } from './constants'


const app: Express = express()
const port: number = 8000

const sequelize: Sequelize = new Sequelize('postgres://postgres:root@localhost:5432/SanatoriumResort')

app.use(express.json())

app.get('/allrooms', async (request, response) => {
    const authorized: AuthorizationResponse = await isAuthorized(request, sequelize)

    if (!authorized.authorized) {
        response.status(403).send(UNAUTHORIZED_STRING_MESSAGE)
        return
    }

    const rooms = await sequelize.query('SELECT * FROM rooms', { type: QueryTypes.SELECT })
    response.send(rooms)
})

app.get('/allvacationers', async (request, response) => {
    const authorized: AuthorizationResponse = await isAuthorized(request, sequelize)

    if (!authorized.authorized || authorized.type === 'vacationer') {
        response.status(403).send(UNAUTHORIZED_STRING_MESSAGE)
        return
    }

    const users = await sequelize.query(`
    SELECT abstract_users.name, abstract_users.surname, abstract_users.email, rooms.number, vacationers.rests_from, vacationers.rests_to  FROM vacationers
    INNER JOIN abstract_users ON abstract_users.user_id = vacationers.id
    INNER JOIN rooms ON vacationers.room = rooms.room_id
    `, { type: QueryTypes.SELECT })

    response.status(200).send(users)
})

app.get('/allmedicals', async (request, response) => {
    const authorized: AuthorizationResponse = await isAuthorized(request, sequelize)

    if (!authorized.authorized) {
        response.status(403).send(UNAUTHORIZED_STRING_MESSAGE)
        return
    }

    const users = await sequelize.query(`
        SELECT abstract_users.name, abstract_users.surname, abstract_users.email, rooms.number, medical_employees.cabinet, medical_jobs.job_title  FROM medical_employees
        INNER JOIN abstract_users ON abstract_users.user_id = medical_employees.id
        INNER JOIN medical_jobs ON medical_jobs.medical_job_id = medical_employees.job
        INNER JOIN rooms ON medical_employees.room = rooms.room_id
    `, { type: QueryTypes.SELECT })

    response.status(200).send(users)
})

app.get('/alladmins', async (request, response) => {
    const authorized: AuthorizationResponse = await isAuthorized(request, sequelize)

    if (authorized.authorized) {
        const users = await sequelize.query(`
            SELECT abstract_users.name, abstract_users.surname, abstract_users.email, rooms.number  FROM administrators
            INNER JOIN abstract_users ON abstract_users.user_id = administrators.id
            INNER JOIN rooms ON administrators.room = rooms.room_id
    `,
            { type: QueryTypes.SELECT }
        )
        response.status(200).send(users)
        return
    }

    response.status(403).send()
})

app.get('/allusers', async (request, response) => {
    const authorized: AuthorizationResponse = await isAuthorized(request, sequelize)

    console.log(authorized)
    if (authorized.authorized && authorized.type === 'administrator') {
        const users = await sequelize.query(`
            (SELECT abstract_users.name, abstract_users.surname, abstract_users.email, rooms.number FROM administrators
            INNER JOIN abstract_users ON abstract_users.user_id = administrators.id
            INNER JOIN rooms ON rooms.room_id = administrators.room)
            UNION
            (SELECT abstract_users.name, abstract_users.surname, abstract_users.email, rooms.number FROM medical_employees
            INNER JOIN abstract_users ON abstract_users.user_id = medical_employees.id
            INNER JOIN rooms ON rooms.room_id = medical_employees.room)
            UNION
            (SELECT abstract_users.name, abstract_users.surname, abstract_users.email, rooms.number FROM vacationers
            INNER JOIN abstract_users ON abstract_users.user_id = vacationers.id
            INNER JOIN rooms ON rooms.room_id = vacationers.room)
    `,
            { type: QueryTypes.SELECT }
        )

        response.status(200).send(users)
        return
    }

    response.status(403).send(UNAUTHORIZED_STRING_MESSAGE)
})

app.get('/roomswithplaces', async (request, response) => {
    const authorized: AuthorizationResponse = await isAuthorized(request, sequelize)

    //console.log(authorized)
    if (authorized.authorized && authorized.type === 'administrator') {
        const roomsWithPlaces = await sequelize.query(`SELECT * FROM get_rooms_with_free_places()`,
            { type: QueryTypes.SELECT })
        response.status(200).send(roomsWithPlaces)
        return
    }

    response.status(403).send(UNAUTHORIZED_STRING_MESSAGE)
})

app.get('/checkauthorization', async (request, response) => {
    const authorized = await isAuthorized(request, sequelize)
    response.send(authorized)
})


app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})
