/*
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

package org.yardstick.examples.echo;

import com.beust.jcommander.*;
import org.yardstick.util.*;

/**
 * Echo server benchmark arguments.
 */
public class EchoServerBenchmarkArguments {
    /** Port echo server listens on. */
    @SuppressWarnings("FieldCanBeLocal")
    @Parameter(names = "--port", description = "Echo server port")
    private int port = 54321;

    /** Port echo server listens on. */
    @SuppressWarnings("FieldCanBeLocal")
    @Parameter(names = "--host", description = "Echo server port")
    private String host = "127.0.0.1";

    /**
     * @return Client flag.
     */
    public int port() {
        return port;
    }

    /**
     * @return Local host.
     */
    public String host() {
        return host;
    }

    /**
     * @return Short string.
     */
    @BenchmarkToShortString
    public String toShortString() {
        return "--host=" + host + "_--port=" + port;
    }

    /** {@inheritDoc} */
    @Override public String toString() {
        return "EchoServerBenchmarkArguments [" +
            "port=" + port +
            ", host='" + host + '\'' +
            ']';
    }
}
