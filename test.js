const { createClient } = require('@supabase/supabase-js');
const supabase = createClient('https://lkxoqgkegpunvmmyeeji.supabase.co', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxreG9xZ2tlZ3B1bnZtbXllZWppIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE0OTUzNDQsImV4cCI6MjA5NzA3MTM0NH0.lf36Ht5yf1eJ9pXeZBii_ibifCCD3Xe2bjrtfgMxM0Q');

async function run() {
    let { data, error } = await supabase.from('settings').select('*');
    console.log('Settings table currently:', data);

    if (data && data.length === 0) {
        console.log('Inserting default row...');
        let res = await supabase.from('settings').insert([{ event_date: '2026-12-31' }]).select();
        console.log('Insert result:', res);
    }
}
run();
