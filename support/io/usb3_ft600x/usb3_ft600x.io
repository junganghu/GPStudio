<?xml version="1.0" encoding="UTF-8"?>
<io driver="usb3_ft600x" categ="communication" master_count="0" pi_size_addr_rel="0" desc="">
  <parts>
    <part name="inputs">
      <svg width="160" height="200">
        <rect width="160" height="200" x="0" y="0" fill="lightgray"/>
        <text x="80" y="150" font-size="14">SS</text>
        <g transform="rotate(90)">
          <text x="50" y="-140" font-size="14">To computer</text>
        </g>
        <g id="usb" transform="translate(40,50) scale(0.2)">
          <path d="M393.221,56.001H81.224c-13.202,0-24.002,10.795-24.002,24.001v311.999c0,13.202,10.8,24.002,24.002,24.002h311.998   c13.203,0,24.002-10.8,24.002-24.002V80.002C417.223,66.796,406.424,56.001,393.221,56.001z M316.239,203.177c0,2.209-1.791,4-4,4   h-9.76l0.01,16.667c0,11.14-6.158,21.546-11.951,27.608c-0.031,0.034-0.074,0.077-0.104,0.112c-0.01,0-0.01,0.013-0.01,0.013   c-0.043,0.047-0.086,0.077-0.129,0.125c-0.738,0.737-38.58,39.392-38.58,39.392c-2.18,2.735-3.625,6.467-3.711,9.971v13.138   c16.123,4.72,27.51,19.674,27.51,36.721c0,21.11-17.172,38.282-38.274,38.282c-21.103,0-38.266-17.172-38.266-38.282   c0-17.047,11.373-31.983,27.483-36.721v-0.764c-0.086-3.409-1.531-7.158-3.961-10.187c-0.056,0-37.562-35.375-38.312-36.078   c-0.107-0.112-0.211-0.203-0.314-0.328c-6.835-7.235-11.93-23.363-11.93-33.049l0.008-7.701   c-8.326-4.082-13.741-12.568-13.741-21.943c0-13.522,11.002-24.524,24.523-24.524c13.526,0,24.523,11.002,24.523,24.524   c0,9.375-5.423,17.861-13.75,21.943c0.009,1.247,0.009,4.388,0.009,13.591c0.077,3.391,1.522,7.14,3.969,10.203l28.977,27.268   V136.66h-20.912c-1.488,0-2.852-0.828-3.542-2.14c-0.695-1.32-0.592-2.917,0.25-4.134l31.703-45.863   c0.742-1.078,1.976-1.726,3.292-1.726c1.312,0,2.536,0.647,3.287,1.726l31.798,45.854c0.842,1.226,0.945,2.813,0.254,4.134   c-0.693,1.32-2.062,2.148-3.547,2.148h-21.037v127.48l29.209-29.985c2.188-2.749,3.633-6.498,3.715-9.997   c0-8.763,0-13.944,0.004-16.981H271.2c-2.209,0-4-1.791-4-4v-41.048c0-2.209,1.791-4,4-4h41.039c2.209,0,4,1.791,4,4V203.177z" fill="blue"/>
        </g>
      </svg>
      <flows>
        <flow name="in0"/>
        <flow name="in1"/>
        <flow name="in2"/>
        <flow name="in3"/>
      </flows>
    </part>
    <part name="outputs">
      <svg width="160" height="200">
        <rect width="160" height="200" x="0" y="0" fill="lightgray"/>
        <text x="60" y="150" font-size="14">SS</text>
        <g transform="rotate(90)">
          <text x="50" y="-10" font-size="14">From computer</text>
        </g>
        <g id="usb" transform="translate(20,50) scale(0.2)">
          <path d="M393.221,56.001H81.224c-13.202,0-24.002,10.795-24.002,24.001v311.999c0,13.202,10.8,24.002,24.002,24.002h311.998   c13.203,0,24.002-10.8,24.002-24.002V80.002C417.223,66.796,406.424,56.001,393.221,56.001z M316.239,203.177c0,2.209-1.791,4-4,4   h-9.76l0.01,16.667c0,11.14-6.158,21.546-11.951,27.608c-0.031,0.034-0.074,0.077-0.104,0.112c-0.01,0-0.01,0.013-0.01,0.013   c-0.043,0.047-0.086,0.077-0.129,0.125c-0.738,0.737-38.58,39.392-38.58,39.392c-2.18,2.735-3.625,6.467-3.711,9.971v13.138   c16.123,4.72,27.51,19.674,27.51,36.721c0,21.11-17.172,38.282-38.274,38.282c-21.103,0-38.266-17.172-38.266-38.282   c0-17.047,11.373-31.983,27.483-36.721v-0.764c-0.086-3.409-1.531-7.158-3.961-10.187c-0.056,0-37.562-35.375-38.312-36.078   c-0.107-0.112-0.211-0.203-0.314-0.328c-6.835-7.235-11.93-23.363-11.93-33.049l0.008-7.701   c-8.326-4.082-13.741-12.568-13.741-21.943c0-13.522,11.002-24.524,24.523-24.524c13.526,0,24.523,11.002,24.523,24.524   c0,9.375-5.423,17.861-13.75,21.943c0.009,1.247,0.009,4.388,0.009,13.591c0.077,3.391,1.522,7.14,3.969,10.203l28.977,27.268   V136.66h-20.912c-1.488,0-2.852-0.828-3.542-2.14c-0.695-1.32-0.592-2.917,0.25-4.134l31.703-45.863   c0.742-1.078,1.976-1.726,3.292-1.726c1.312,0,2.536,0.647,3.287,1.726l31.798,45.854c0.842,1.226,0.945,2.813,0.254,4.134   c-0.693,1.32-2.062,2.148-3.547,2.148h-21.037v127.48l29.209-29.985c2.188-2.749,3.633-6.498,3.715-9.997   c0-8.763,0-13.944,0.004-16.981H271.2c-2.209,0-4-1.791-4-4v-41.048c0-2.209,1.791-4,4-4h41.039c2.209,0,4,1.791,4,4V203.177z" fill="blue"/>
        </g>
      </svg>
      <flows>
        <flow name="out0"/>
        <flow name="out1"/>
      </flows>
    </part>
  </parts>
  <files>
    <file name="usb3_ft600x.io" type="io" group="blockdef" path="usb3_ft600x.io"/>
    <file name="usb3_ft600x.vhd" type="vhdl" group="hdl" path="hdl/usb3_ft600x.vhd"/>
  </files>
  <resets>
    <reset name="reset_n" group="reset_n" direction="in"/>
  </resets>
  <ports>
    <port name="ftreset_n" type="out" size="1"/>
    <port name="ftclk" type="in" size="1"/>
    <port name="be" type="inout" size="2"/>
    <port name="data" type="inout" size="16"/>
    <port name="txe_n" type="in" size="1"/>
    <port name="rxf_n" type="in" size="1"/>
    <port name="siwu_n" type="out" size="1"/>
    <port name="wr_n" type="out" size="1"/>
    <port name="rd_n" type="out" size="1"/>
    <port name="oe_n" type="out" size="1"/>
  </ports>
  <flows>
    <flow name="out0" size="8" type="out"/>
    <flow name="out1" size="8" type="out"/>
    <flow name="in0" size="8" type="in"/>
    <flow name="in1" size="8" type="in"/>
  </flows>
  <pins/>
  <com_driver driverio="usb">
    <com_connects>
      <com_connect link="out0" id="1" type="flowout"/>
      <com_connect link="out1" id="2" type="flowout"/>
      <com_connect link="in0" id="128" type="flowin"/>
      <com_connect link="in1" id="129" type="flowin"/>
      <com_connect link="" id="15" type="paramout"/>
    </com_connects>
    <com_params>
      <com_param name="vendorId" value="0x0403"/>
      <com_param name="productId" value="0x601E"/>
      <com_param name="EPIN" value="0x02"/>
      <com_param name="EPOUT" value="0x82"/>
      <com_param name="interface" value="1"/>
    </com_params>
  </com_driver>
</io>
