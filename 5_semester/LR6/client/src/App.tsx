import React from 'react'
import './App.css'
import {
    BrowserRouter as Router,
    Switch,
    Route
} from 'react-router-dom'
import {Main} from './pages/Main'
import {Navigation} from './components/Navigation'
import {Authorize} from './pages/Authorize'


export const App = (): JSX.Element => {
    return (
        <div className="container">
            <Router>
                <Navigation/>
                <Switch>
                    <Route exact path="/">
                        <Main/>
                    </Route>
                    <Route path="/auth">
                       <Authorize/>
                    </Route>
                </Switch>
            </Router>
        </div>
    )
}

