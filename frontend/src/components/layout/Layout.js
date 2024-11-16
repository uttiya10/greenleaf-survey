import { Link, Outlet } from "react-router-dom";

export default function Layout() {
    return (
        <div>
            <nav>
                <ul>
                    <li>
                        <Link to="/">Saved Surveys</Link>
                    </li>
                    <li>
                        <Link to="/create">Create Survey</Link>
                    </li>
                </ul>
            </nav>
            <Outlet />
        </div>
    );
}