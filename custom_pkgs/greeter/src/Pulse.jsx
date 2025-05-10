import {For} from "solid-js";
import "./Pulse.css";

function Pulse(props) {
    let text = props.children.toString().split("");
    return <>
        <h1>
            <For each={text}>
                {(item, index) => {
                    const delay = `${index() * 70}ms`;
                    return <span style={{ "animation-delay": delay }} class="letter">{item}</span>;
                }}
            </For>
        </h1>
    </>
}

export default Pulse;
