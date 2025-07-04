
addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request))
})

const CONFIG = {
  uuid: 'REPLACE_WITH_YOUR_UUID',
  path: '/sub',
}

async function handleRequest(request) {
  const url = new URL(request.url)
  if (url.pathname.startsWith(CONFIG.path)) {
    return new Response(JSON.stringify({
      v: 2,
      ps: "My-Trojan",
      add: "example.com",
      port: 443,
      id: CONFIG.uuid,
      aid: 0,
      net: "tcp",
      type: "none",
      host: "",
      path: "",
      tls: "tls"
    }), {
      headers: { 'content-type': 'application/json' }
    })
  }
  return new Response("Welcome to your own Trojan Worker!", {
    headers: { 'content-type': 'text/plain' }
  })
}
