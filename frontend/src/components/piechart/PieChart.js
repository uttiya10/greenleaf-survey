import React from 'react';
import { Pie } from 'react-chartjs-2';
import { Chart as ChartJS, ArcElement, Tooltip, Legend } from 'chart.js';
import './PieChart.css';

ChartJS.register(ArcElement, Tooltip, Legend);

export default function PieChart({ data, text }) {
    const chartData = {
        labels: data.map(item => item.label),
        datasets: [
            {
                label: "Response Data",
                data: data.map((item) => item.value),
                backgroundColor: [
                    '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40',
                ], // Customize colors
                hoverBackgroundColor: [
                    '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40',
                ]
            }
        ]
    };

    return (
        <div class="mc-res-container">
            <h2>{text}</h2>
            <Pie data={chartData} />
        </div>
    );
}